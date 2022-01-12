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
        DataSet ds = null;
        DataTable dtData = null;
        SqlCommand sqlCmd = null;
        #endregion

        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateControl("drpInventoryRegisterNo");
            }
            lblError.Text = string.Empty;
        }

        protected void PopulateControl(string controlName)
        {
            try
            {
                ds = new DataSet();
                ds = FetchIssueMasterDetails();
                //Table 0  Select* from tbIssuedetails WHERE InventoryId=@InventoryId
                //Table 1 SELECT UserId, UserName from tbUserDetails
                //Table 2 SELECT DISTINCT InventoryRegisterNo from tbInventoryEntries ORDER BY InventoryRegisterNo
                //Table 3 SELECT DISTINCT InventoryPageNo from tbInventoryEntries WHERE InventoryRegisterNo = @InventoryRegisterNo ORDER BY InventoryPageNo
                //Table 4 SELECT InventoryId, InventoryName from tbInventoryEntries WHERE InventoryRegisterNo = @InventoryRegisterNo AND InventoryPageNo = @InventoryPageNo
                if (ds.Tables.Count > 0)
                {
                        switch (controlName)
                        {
                        case "drpInventoryRegisterNo":
                            if (ds.Tables[2].Rows.Count > 0)//Register Numbers
                            {
                                drpInventoryRegisterNo.DataSource = ds.Tables[2];
                                drpInventoryRegisterNo.DataTextField = "InventoryRegisterNo";
                                drpInventoryRegisterNo.DataValueField = "InventoryRegisterNo";
                                drpInventoryRegisterNo.DataBind();
                                ListItem li = new ListItem("Select Register", "-1");
                                li.Selected = true;
                                drpInventoryRegisterNo.Items.Add(li);
                            }
                            break;
                        case "drpInventoryPageNo":
                            if (ds.Tables[3].Rows.Count > 0) //Page nUmbers of a register
                            {
                                drpInventoryPageNo.DataSource = ds.Tables[3];
                                drpInventoryPageNo.DataTextField = "InventoryPageNo";
                                drpInventoryPageNo.DataValueField = "InventoryPageNo";
                                drpInventoryPageNo.DataBind();
                                ListItem li = new ListItem("Select Page", "-1");
                                li.Selected = true;
                                drpInventoryPageNo.Items.Add(li);
                            }
                            break;
                        case "drpInventoryId":
                            if (ds.Tables[4].Rows.Count > 0) //Inventory items on a register no and page no
                            {
                                drpInventoryId.DataSource = ds.Tables[4];
                                drpInventoryId.DataTextField = "InventoryName";
                                drpInventoryId.DataValueField = "InventoryId";
                                drpInventoryId.DataBind();
                                ListItem li = new ListItem("Select Item", "-1");
                                li.Selected = true;
                                drpInventoryId.Items.Add(li);
                                // drpInventoryId.SelectedValue = "-1";
                            }
                            break;
                        case "drpUserId":
                            if (ds.Tables[1].Rows.Count > 0) //User Id Table
                            {
                                drpUserId.DataSource = ds.Tables[1];
                                drpUserId.DataTextField = "UserName";
                                drpUserId.DataValueField = "UserId";
                                drpUserId.DataBind();
                            }
                            break;
                        case "grdIssueMaster":
                            if (ds.Tables[0].Rows.Count > 0) //Issue Table of selected inventory id
                            {
                                grdIssueMaster.DataSource = ds.Tables[0];
                                grdIssueMaster.DataBind();
                            }
                            break;
                        
                        default:
                            {
                                grdIssueMaster.DataSource = ds.Tables[0];
                                grdIssueMaster.DataBind();
                            }
                            break;
                    }
                }
                else
                {
                    grdIssueMaster.DataSource = ds.Tables[0];
                    grdIssueMaster.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
            finally
            {
               
            }
        }

        private DataSet FetchIssueMasterDetails()
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
                sqlCmd.Parameters.AddWithValue("@InventoryRegisterNo"   , drpInventoryRegisterNo.SelectedValue);
                sqlCmd.Parameters.AddWithValue("@InventoryPageNo"       , drpInventoryPageNo.SelectedValue);
                sqlCmd.Parameters.AddWithValue("@InventoryId"           , drpInventoryId.SelectedValue);
                sqlCmd.Parameters.AddWithValue("@ActionType"            , "FetchIssueDetails");
                SqlDataAdapter sqlSda = new SqlDataAdapter(sqlCmd);
                sqlSda.Fill(ds);

                //Table 0  Select* from tbIssuedetails WHERE InventoryId=@InventoryId
                //Table 1 SELECT UserId, UserName from tbUserDetails
                //Table 2 SELECT DISTINCT InventoryRegisterNo from tbInventoryEntries ORDER BY InventoryRegisterNo
                //Table 3 SELECT DISTINCT InventoryPageNo from tbInventoryEntries WHERE InventoryRegisterNo = @InventoryRegisterNo ORDER BY InventoryPageNo
                //Table 4 SELECT InventoryId, InventoryName from tbInventoryEntries WHERE InventoryRegisterNo = @InventoryRegisterNo AND InventoryPageNo = @InventoryPageNo

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

        //private DataTable FetchIssueMasterDetails(string id)
        //{
        //    try
        //    {
        //        if (conn.State == ConnectionState.Closed)
        //        {
        //            conn.Open();
        //        }
        //        //Get SubCategory Details for SubCategoryGrid
        //        dtData = new DataTable();
        //        sqlCmd = new SqlCommand("spInventories", conn);
        //        sqlCmd.CommandType = CommandType.StoredProcedure;
        //        sqlCmd.Parameters.AddWithValue("@CategoryId", id);
        //        sqlCmd.Parameters.AddWithValue("@ActionType", "FetchIssueDetails");
        //        SqlDataAdapter sqlSda = new SqlDataAdapter(sqlCmd);
        //        sqlSda.Fill(dtData);
        //    }
        //    catch (Exception ex)
        //    {
        //        lblError.Text = ex.Message;
        //    }
        //    finally
        //    {
        //        sqlCmd.Dispose();
        //        dtData.Dispose();
        //    }
        //    return dtData;
        //}

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
                sqlCmd.Parameters.AddWithValue("@UserId", drpUserId.SelectedValue);
                sqlCmd.Parameters.AddWithValue("@IssueDate", txtIssueDate.Text);
                sqlCmd.Parameters.AddWithValue("@IssuedBy", "1");//filhal
                sqlCmd.Parameters.AddWithValue("@IssueQuantity", txtIssueQuantity.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryId", drpInventoryId.SelectedItem.Value);
                sqlCmd.Parameters.AddWithValue("@IsReceived", chkIsReceived.Checked);
                sqlCmd.Parameters.AddWithValue("@IssuerRemarks", txtIssuerRemarks.Text);
                sqlCmd.Parameters.AddWithValue("@ReceiptRemarks", txtReceiptRemarks.Text);
                //add updated created by on
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblError.Text = "Record Saved Successfully";
                    //lblMsgSuccess.Visible = true;
                    lblError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblError.Font.Size = 16;
                    txtIssueDate.Text = string.Empty;
                    txtIssueQuantity.Text = string.Empty;
                    txtIssuerRemarks.Text = string.Empty;
                    txtReceiptRemarks.Text = string.Empty;
                    chkIsReceived.Checked = false;
                    PopulateControl("grdIssueMaster");
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
            PopulateControl("grdIssueMaster");
        }

        protected void grdIssueMaster_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            //if (e.Row.RowType == DataControlRowType.DataRow)
            //{
            //    string categoryId = grdIssueMaster.DataKeys[e.Row.RowIndex].Value.ToString();
            //    GridView grdSubCategoryMaster = e.Row.FindControl("grdSubCategoryMaster") as GridView;
            //    dtData = new DataTable();
            //    dtData = FetchIssueMasterDetails(categoryId);
            //    grdSubCategoryMaster.DataSource = dtData;
            //    grdSubCategoryMaster.DataBind();
            //}
        }

        protected void grdIssueMaster_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            //Setting the EditIndex property to -1 to cancel the Edit mode in Gridview  
            grdIssueMaster.EditIndex = -1;
            PopulateControl("grdIssueMaster");
        }

        protected void grdIssueMaster_RowEditing(object sender, GridViewEditEventArgs e)
        {
            //NewEditIndex property used to determine the index of the row being edited.  
            grdIssueMaster.EditIndex = e.NewEditIndex;
            PopulateControl("grdIssueMaster");
        }

        protected void grdIssueMaster_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            
            //Finding the controls from Gridview for the row which is going to update  
            Label   LblIssueId          = grdIssueMaster.Rows[e.RowIndex].FindControl("lblIssueId")         as Label;
            Label   LblUserId           = grdIssueMaster.Rows[e.RowIndex].FindControl("lblUserId")          as Label;
            Label   LblInventoryId      = grdIssueMaster.Rows[e.RowIndex].FindControl("lblInventoryId") as Label;
            Label   LblIssuedBy         = grdIssueMaster.Rows[e.RowIndex].FindControl("lblIssuedBy") as Label;
            TextBox TxtIssueDate        = grdIssueMaster.Rows[e.RowIndex].FindControl("txtIssueDate")       as TextBox;
            TextBox TxtIssueQuantity    = grdIssueMaster.Rows[e.RowIndex].FindControl("txtIssueQuantity")   as TextBox;
            CheckBox ChkIsReceived      = grdIssueMaster.Rows[e.RowIndex].FindControl("chkIsReceived")      as CheckBox;
            TextBox TxtIssuerRemarks    = grdIssueMaster.Rows[e.RowIndex].FindControl("txtIssuerRemarks")   as TextBox;
            TextBox TxtReceiptRemarks   = grdIssueMaster.Rows[e.RowIndex].FindControl("txtReceiptRemarks")  as TextBox;
            // DropDownList drpUserId_grid = grdIssueMaster.Rows[e.RowIndex].FindControl("drpUserId_grid")  as DropDownList;
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ActionType"    , "SaveIssueDetails");
                sqlCmd.Parameters.AddWithValue("@IssueId"       , LblIssueId.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryId"   , LblInventoryId.Text);
                sqlCmd.Parameters.AddWithValue("@IssuedBy"      , LblIssuedBy.Text);
                sqlCmd.Parameters.AddWithValue("@UserId"        , LblUserId.Text);
                sqlCmd.Parameters.AddWithValue("@IssueDate"     , TxtIssueDate.Text);
                sqlCmd.Parameters.AddWithValue("@IssueQuantity" , TxtIssueQuantity.Text);
                sqlCmd.Parameters.AddWithValue("@IsReceived"    , ChkIsReceived.Checked);
                sqlCmd.Parameters.AddWithValue("@IssuerRemarks" , TxtIssuerRemarks.Text);
                sqlCmd.Parameters.AddWithValue("@ReceiptRemarks", TxtReceiptRemarks.Text);
                //add updated by updated on

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
            PopulateControl("grdIssueMaster");
        }

        protected void grdIssueMaster_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                Label lblIssueId = grdIssueMaster.Rows[e.RowIndex].FindControl("lblIssueId") as Label;
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ActionType", "DeleteIssueDetails");
                sqlCmd.Parameters.AddWithValue("@IssueId", lblIssueId.Text);

                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblError.Text = "Record Deleted Successfully";
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
            // //Call ShowData method for displaying updated data  
            PopulateControl("grdIssueMaster");
        }

        protected void drpInventoryRegisterNo_SelectedIndexChanged(object sender, EventArgs e)
        {
            PopulateControl("drpInventoryPageNo");
        }

        protected void drpInventoryPageNo_SelectedIndexChanged(object sender, EventArgs e)
        {
            PopulateControl("drpInventoryId");
        }

        protected void drpInventoryId_SelectedIndexChanged(object sender, EventArgs e)
        {
            PopulateControl("drpUserId");
            PopulateControl("grdIssueMaster");
        }



        //protected void btnAddIssueMaster_Click(object sender, EventArgs e)
        //{
        //    dvAddIssueMasterDetails.Visible = true;
        //}
        #endregion
    }
}
