using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Collections;
using System.Web.UI.HtmlControls;

namespace Inventory
{
    public partial class _Default : Page
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultInventoryConnection"].ConnectionString);
        DataSet ds = null;
        DataTable dtData = null;
        SqlCommand sqlCmd = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated || Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            else
            {
                string UserRole = Session["UserRoleX"].ToString();
                if (this.Master.PageAccessList.ContainsKey(UserRole))
                {
                    string[] AllowedPages = this.Master.PageAccessList[UserRole];
                    foreach (string PageName in AllowedPages)
                    {
                        HyperLink link = new HyperLink();
                        if (   PageName == "Default"
                            || PageName == "LogIn"
                            || PageName == "LogOut"
                            || PageName == "UnauthorizedAccess")
                        {
                            //nothing, dont display 
                        }
                        else //dynamically generate and display permissible page Links
                        {
                            link.ID = PageName;
                            link.NavigateUrl = "~/InventorySystem/" + PageName + ".aspx";
                            link.Text = PageName ;
                            link.Attributes["class"] = "btn btn-primary btn - lg";
                            HtmlGenericControl li = new HtmlGenericControl("li"); //Create html control <li>
                            li.Controls.Add(link); //add hyperlink to <li>
                            
                            ulPermittedPagesList.Controls.Add(li);  //add <li> to <ul>
                        }
                    }
                }
                else
                {
                    Response.Write("UserID not found in PageAccessList" +
                                    " <br/><a href='~/Login.aspx'>Login Again</a>");
                }
            }
            if (!IsPostBack)
            {
                //GetCommentDetails();
            }
            lblError.Text = string.Empty;
        }

        protected void GetCommentDetails()
        {
            try
            {
                ds = new DataSet();
                ds = FetchCommentDetails();
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    grdComments.DataSource = ds.Tables[0];
                    grdComments.DataBind();
                    // countFreshApplication.InnerText = ds.Tables[0].Rows.Count.ToString();
                }
                else
                {
                    grdComments.DataSource = ds.Tables[0];
                    grdComments.DataBind();
                    //countFreshApplication.InnerText = "0";
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
        }

        private DataSet FetchCommentDetails()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                ds = new DataSet();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchCommentDetails");
                SqlDataAdapter sqlSda = new SqlDataAdapter(sqlCmd);
                sqlSda.Fill(ds);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
            finally
            {
                sqlCmd.Dispose();
                ds.Dispose();
            }
            return ds;
        }
    
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveCommentDetails");
                sqlCmd.Parameters.AddWithValue("@CommentCreatorName", txtCommenter.Text);
                sqlCmd.Parameters.AddWithValue("@CommentPageName", drpPageName.SelectedItem.Value);
                sqlCmd.Parameters.AddWithValue("@CommentDescription", txtCommentDescription.Text);
                sqlCmd.Parameters.AddWithValue("@CommentSubject", txtSubject.Text);
                sqlCmd.Parameters.AddWithValue("@CommentCreatedOn", DateTime.Now);
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblError.Text = "Comment Saved Successfully";
                    lblError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblError.Font.Size = 16;
                    txtCommenter.Text = string.Empty;
                    txtCommentDescription.Text = string.Empty;
                    txtSubject.Text = string.Empty;
                    drpPageName.SelectedIndex = -1;
                    GetCommentDetails();
                }
                else
                    lblError.Text = ("Please Try Again !!!");
            }

            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
            finally
            {
                dtData.Dispose();
                sqlCmd.Dispose();
                conn.Close();
            }
        }

        protected void grdComments_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {

        }
    }
}