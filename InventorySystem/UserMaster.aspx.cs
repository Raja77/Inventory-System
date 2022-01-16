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
    public partial class UserMaster : Page
    {
        #region Properties
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultInventoryConnection"].ConnectionString);
        DataSet ds = null;
        DataTable dtData = null;
        SqlCommand sqlCmd = null;
        #endregion

        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetUserMasterDetails();
            }
            lblError.Text = string.Empty;
        }

        protected void GetUserMasterDetails()
        {
            try
            {
                ds = new DataSet();
                ds = FetchUserMasterDetails();
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    grdUserMaster.DataSource = ds.Tables[0];
                    grdUserMaster.DataBind();
                   // countFreshApplication.InnerText = ds.Tables[0].Rows.Count.ToString();
                }
                else
                {
                    grdUserMaster.DataSource = ds.Tables[0];
                    grdUserMaster.DataBind();
                    //countFreshApplication.InnerText = "0";
                }                
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
        }

        private DataSet FetchUserMasterDetails()
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
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchUserDetails");
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
                conn.Close();
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
                //dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                if (btnSubmit.Text == "Update User")
                {
                    sqlCmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
                }
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveUserDetails");
                sqlCmd.Parameters.AddWithValue("@UserName", txtUserName.Text);
                sqlCmd.Parameters.AddWithValue("@UserEmail", txtUserEmail.Text);
                sqlCmd.Parameters.AddWithValue("@UserType", drpUserType.SelectedItem.Value);
                sqlCmd.Parameters.AddWithValue("@UserPassword", txtPassword.Text);
                sqlCmd.Parameters.AddWithValue("@IssuerName", txtIssuerName.Text);
                sqlCmd.Parameters.AddWithValue("@IsActive", 0);
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {                    
                    if (btnSubmit.Text == "Update User")
                    {
                        lblError.Text = "Record Updated Successfully";
                        lblError.ForeColor = System.Drawing.Color.ForestGreen;
                    }
                    else
                    {
                        lblError.Text = "Record Saved Successfully";
                        lblError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    }
                    btnCancel_Click(null, null);                    
                    lblError.Font.Size = 16;                    
                    GetUserMasterDetails();
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
               // dtData.Dispose();
                sqlCmd.Dispose();
                conn.Close();
            }
        }

        protected void grdUserMaster_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdUserMaster.PageIndex = e.NewPageIndex;
            this.GetUserMasterDetails();
        }

        #endregion

        protected void grdUserMaster_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string[] arg = new string[6];
            arg = e.CommandArgument.ToString().Split(';');
            Session["UserId"] = arg[0];
            Session["UserName"] = arg[1];
            Session["UserEmail"] = arg[2];
            Session["UserType"] = arg[3];
            Session["Password"] = arg[4];
            Session["IssuerName"] = arg[5];
            if (e.CommandName == "EditRecord")
            {
                txtUserName.Text = Session["UserName"].ToString();
                txtUserEmail.Text = Session["UserEmail"].ToString();
                drpUserType.SelectedValue = Session["UserType"].ToString();
                txtPassword.Text = Session["Password"].ToString();
                txtIssuerName.Text = Session["IssuerName"].ToString();
                btnSubmit.Visible = true;
                btnSubmit.Text = "Update User";
                txtUserName.Enabled = txtUserEmail.Enabled = drpUserType.Enabled = txtPassword.Enabled =
               txtIssuerName.Enabled = true;
            }
            if (e.CommandName == "ViewRecord")
            {
                txtUserName.Text = Session["UserName"].ToString();
                txtUserEmail.Text = Session["UserEmail"].ToString();
                drpUserType.SelectedValue = Session["UserType"].ToString();
                txtPassword.Text = Session["Password"].ToString();
                txtIssuerName.Text = Session["IssuerName"].ToString();
                txtUserName.Enabled = txtUserEmail.Enabled = drpUserType.Enabled = txtPassword.Enabled = txtIssuerName.Enabled = false;
                btnSubmit.Visible = false;
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            btnSubmit.Visible = true;
            btnSubmit.Text = "Create User";
            txtUserEmail.Text = string.Empty;
            txtUserName.Text = string.Empty;
            txtPassword.Text = string.Empty;
            txtIssuerName.Text = string.Empty;
            drpUserType.SelectedIndex = -1;
            txtUserName.Enabled = txtUserEmail.Enabled = drpUserType.Enabled = txtPassword.Enabled = 
                txtIssuerName.Enabled = true;

        }

        protected void grdUserMaster_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //Find the Edit Link Button control.
                LinkButton lnkbtnEdit = (e.Row.FindControl("lnkEdit") as LinkButton);
                if (Session["UserRoleX"].Equals("SuperAdmin") && Session["UserNameX"].Equals("Admin"))
                    lnkbtnEdit.Visible = true;
                else
                    lnkbtnEdit.Visible = false;

            }

            }
    }
}