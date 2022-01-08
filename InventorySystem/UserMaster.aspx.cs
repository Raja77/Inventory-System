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
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveUserDetails");
                sqlCmd.Parameters.AddWithValue("@UserName", txtUserName.Text);
                sqlCmd.Parameters.AddWithValue("@UserEmail", txtUserEmail.Text);
                sqlCmd.Parameters.AddWithValue("@UserType", drpUserType.SelectedItem.Text);
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblError.Text = "Record Saved Successfully";
                    lblError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblError.Font.Size = 16;
                    txtUserEmail.Text = string.Empty;
                    txtUserName.Text = string.Empty;
                    drpUserType.SelectedIndex = -1;
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


    }
}