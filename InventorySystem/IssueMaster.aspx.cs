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
using System.Drawing;
using System.Net;
using System.Data.SqlTypes;
using System.Globalization;

namespace Inventory
{
    public partial class IssueMaster : Page
    {
        #region Properties
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultInventoryConnection"].ConnectionString);
        DataSet ds, dsSubCat = null;
        DataTable dtData = null;
        SqlCommand sqlCmd = null;
        #endregion

        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetIssueMasterDetails();
            }
            lblError.Text = string.Empty;
        }

        protected void GetIssueMasterDetails()
        {
            try
            {
                ds = new DataSet();
                ds = FetchCategoryMasterDetails();
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    grdIssueMaster.DataSource = ds.Tables[0];
                    grdIssueMaster.DataBind();
                }
                else
                {
                    grdIssueMaster.DataSource = ds.Tables[0];
                    grdIssueMaster.DataBind();
                }

                if (ds.Tables.Count > 0 && ds.Tables[1].Rows.Count > 0)
                {
                    drpInventory.DataSource = ds.Tables[1];
                    drpInventory.DataTextField = "UserName";
                    drpInventory.DataValueField = "UserId";
                    drpInventory.DataBind();
                }
                else
                {
                    drpInventory.DataSource = ds.Tables[1];
                    drpInventory.DataBind();
                }

            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
        }

        private DataSet FetchCategoryMasterDetails()
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
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchCategories");
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

        private DataTable FetchIssueMasterDetails(string id)
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                //Get SubCategory Details for SubCategoryGrid
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@CategoryId", id);
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchIssueDetails");
                SqlDataAdapter sqlSda = new SqlDataAdapter(sqlCmd);
                sqlSda.Fill(dtData);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
            finally
            {
                sqlCmd.Dispose();
                dtData.Dispose();
            }
            return dtData;
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
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveIssueDetails");
                sqlCmd.Parameters.AddWithValue("@UserId", "2");
                sqlCmd.Parameters.AddWithValue("@IssueDate", txtIssueDate.Text);
                sqlCmd.Parameters.AddWithValue("@IssuedBy", "1");
                sqlCmd.Parameters.AddWithValue("@IssueQuantity", txtIssueQuantity.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryId", drpInventory.SelectedItem.Value);
                sqlCmd.Parameters.AddWithValue("@IsReceived", chkIsReceived.Checked);
                sqlCmd.Parameters.AddWithValue("@IssuerRemarks", txtIssuerRemarks.Text);
                sqlCmd.Parameters.AddWithValue("@ReceiptRemarks", txtReceiptRemarks.Text);
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblError.Text = "Record Saved Successfully";
                    //lblMsgSuccess.Visible = true;
                    lblError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblError.Font.Size = 16;
                    GetIssueMasterDetails();
                    dvAddIssueMasterDetails.Visible = false;
                    txtIssueDate.Text = string.Empty;
                    txtIssueQuantity.Text = string.Empty;
                    txtIssuerRemarks.Text = string.Empty;
                    txtReceiptRemarks.Text = string.Empty;
                    chkIsReceived.Checked = false;
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

        protected void grdIssueMaster_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdIssueMaster.PageIndex = e.NewPageIndex;
            this.GetIssueMasterDetails();
        }

        protected void grdIssueMaster_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string categoryId = grdIssueMaster.DataKeys[e.Row.RowIndex].Value.ToString();
                GridView grdSubCategoryMaster = e.Row.FindControl("grdSubCategoryMaster") as GridView;
                dtData = new DataTable();
                dtData = FetchIssueMasterDetails(categoryId);
                grdSubCategoryMaster.DataSource = dtData;
                grdSubCategoryMaster.DataBind();
            }
        }

        protected void grdIssueMaster_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            //Setting the EditIndex property to -1 to cancel the Edit mode in Gridview  
            grdIssueMaster.EditIndex = -1;
            GetIssueMasterDetails();
        }

        protected void grdIssueMaster_RowEditing(object sender, GridViewEditEventArgs e)
        {
            //NewEditIndex property used to determine the index of the row being edited.  
            grdIssueMaster.EditIndex = e.NewEditIndex;
            GetIssueMasterDetails();
        }

        protected void grdIssueMaster_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //Finding the controls from Gridview for the row which is going to update  
            Label categoryId = grdIssueMaster.Rows[e.RowIndex].FindControl("lblCategoryId") as Label;
            TextBox categoryName = grdIssueMaster.Rows[e.RowIndex].FindControl("txtCategoryName") as TextBox;
            TextBox categoryDescription = grdIssueMaster.Rows[e.RowIndex].FindControl("txtCategoryDescription") as TextBox;

            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@CategoryId", categoryId.Text);
                sqlCmd.Parameters.AddWithValue("@CategoryName", categoryName.Text);
                sqlCmd.Parameters.AddWithValue("@CategoryDescription", categoryDescription.Text);
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveCategory");
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblError.Text = "Record Updated Successfully";
                    lblError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblError.Font.Size = 16;
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
            //Setting the EditIndex property to -1 to cancel the Edit mode in Gridview  
            grdIssueMaster.EditIndex = -1;
            //Call ShowData method for displaying updated data  
            GetIssueMasterDetails();
        }

        protected void btnAddIssueMaster_Click(object sender, EventArgs e)
        {
            dvAddIssueMasterDetails.Visible = true;
        }
        #endregion
    }
}
