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

namespace Inventory
{
    public partial class Site_Mobile : System.Web.UI.MasterPage
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultInventoryConnection"].ConnectionString);
        DataSet ds = null;
        SqlCommand sqlCmd = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetCommentDetails();
            }
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
                }
                else
                {
                    grdComments.DataSource = ds.Tables[0];
                    grdComments.DataBind();
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

                string pageName = (new System.IO.FileInfo(Request.Url.AbsolutePath)).Name;
                ds = new DataSet();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@CommentPageName", pageName);
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchPageComments");
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
                string pageName = (new System.IO.FileInfo(Request.Url.AbsolutePath)).Name;
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveCommentDetails");
                sqlCmd.Parameters.AddWithValue("@CommentCreatorName", txtCommenter.Text);
                sqlCmd.Parameters.AddWithValue("@CommentPageName", pageName);
                sqlCmd.Parameters.AddWithValue("@CommentDescription", txtCommentDescription.Text);
                sqlCmd.Parameters.AddWithValue("@CommentSubject", txtSubject.Text);
                sqlCmd.Parameters.AddWithValue("@CommentCreatedOn", DateTime.Now);
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblCommentSubmitError.Text = "Comment Saved Successfully";
                    lblCommentSubmitError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblCommentSubmitError.Font.Size = 16;
                    txtCommenter.Text = string.Empty;
                    txtCommentDescription.Text = string.Empty;
                    txtSubject.Text = string.Empty;
                    GetCommentDetails();
                }
                else
                    lblCommentSubmitError.Text = ("Please Try Again !!!");
            }

            catch (Exception ex)
            {
                lblCommentSubmitError.Text = ex.Message;
            }
            finally
            {

                sqlCmd.Dispose();
                conn.Close();
            }
        }
    }
}