﻿using System;
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
using System.Net.Mail;
using System.Text;

namespace Inventory
{
    public partial class InventoryEntries : Page
    {
        #region Properties
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultInventoryConnection"].ConnectionString);     
        DataSet ds,dsGrid = null;
        DataTable dtData = null;
        SqlCommand sqlCmd = null;

        private string SortDirection
        {
            get { return ViewState["SortDirection"] != null ? ViewState["SortDirection"].ToString() : "ASC"; }
            set { ViewState["SortDirection"] = value; }
        }
        #endregion

        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInventoryEntries();
                CreateIssueDetailsGrid();
                var x= Request.Url.ToString();               
            }
            lblError.Text = string.Empty;
        }       

        public string ConvertNullableBoolToYesNo(object pBool)
        {
            if (pBool != null)
            {
                return (bool)pBool ? "Yes" : "No";
            }
            else
            {
                return "No";
            }
        }

        protected void GetInventoryEntries(string sortExpression = null)
        {
            try
            {
                ds = new DataSet();
                ds = FetchInventoryDetails();
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    grdInventoryMaster.DataSource = ds.Tables[0];
                    grdInventoryMaster.DataBind();
                }
                else
                {
                    grdInventoryMaster.DataSource = ds.Tables[0];
                    grdInventoryMaster.DataBind();
                }
                
                    countInventoryEntries.InnerText = ds.Tables[0].Rows.Count.ToString();
                    countInventoryEntries.Attributes.Add("title", "Inventory Details");
              
                //Bind Category Dropdown
                if (ds.Tables.Count > 0 && ds.Tables[1].Rows.Count > 0)
                {
                    drpCategory.DataSource = ds.Tables[1];
                    drpCategory.DataBind();
                    drpCategory.DataTextField = "CategoryName";
                    drpCategory.DataValueField = "CategoryID";
                    drpCategory.DataBind();
                }
                //Bind Issue Department Dropdown
                if (ds.Tables.Count > 0 && ds.Tables[2].Rows.Count > 0)
                {
                    drpIssuedTo.DataSource = ds.Tables[2];
                    drpIssuedTo.DataTextField = "UserName";
                    drpIssuedTo.DataValueField = "UserId";
                    drpIssuedTo.DataBind();
                }
                else
                {
                    drpIssuedTo.DataSource = ds.Tables[2];
                    drpIssuedTo.DataBind();
                }
                drpCategory_SelectedIndexChanged1(null, null);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
        }
        private DataSet FetchInventoryDetails()
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
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchInventoryEntries");
                SqlDataAdapter sqlSda = new SqlDataAdapter(sqlCmd);
                sqlSda.Fill(ds);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
            finally
            {
                ds.Dispose();
            }
            return ds;
        }
        #endregion

        #region IssueSubGrid
        protected void AddIssueDetail_Click(object sender, EventArgs e)
        {
            //  AddNewRecordRowToGrid();
            DataTable dt = (DataTable)ViewState["IssueDetail"];
            string UserId, IssueDate, IssueQuantity, IssuerRemarks, ReceiptRemarks;
            bool IsReceived;
            UserId = drpIssuedTo.SelectedValue.Trim();
            IssueDate = txtIssueDate.Text.Trim();
            IssueQuantity = txtIssueQuantity.Text.Trim();
            IsReceived = (chkIsReceived.Checked);
            IssuerRemarks = txtIssuerRemarks.Text.Trim();
            ReceiptRemarks = txtReceiptRemarks.Text.Trim();
            // IssuedBy = ""

            dt.Rows.Add(UserId, IssueDate, IssueQuantity, IsReceived, IssuerRemarks, ReceiptRemarks);
            ViewState["IssueDetail"] = dt;
            if (dt.Rows.Count > 0)
            {
                lnkAddIssueDetail.Text = "Add Another Issue Detail";
            }
            this.BindGrid();
           // drpIssuedTo.SelectedValue = "-1";
            txtIssueDate.Text = string.Empty;
            txtIssueQuantity.Text = string.Empty;
            chkIsReceived.Checked = false;
            txtIssuerRemarks.Text = string.Empty;
            txtReceiptRemarks.Text = string.Empty;
        }

        protected void CreateIssueDetailsGrid()
        {
            DataTable dt = new DataTable();
            dt.Columns.AddRange(new DataColumn[6] { new DataColumn("UserId"), new DataColumn("IssueDate"),
                                                    new DataColumn("IssueQuantity"), new DataColumn("IsReceived"),
                                                    new DataColumn("IssuerRemarks"), new DataColumn("ReceiptRemarks")
                                                  });
            ViewState["IssueDetail"] = dt;
            this.BindGrid();
        }
        private DataTable FetchIssueDetails(string id)
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                //Get Issue Details for IssueDetailsGrid
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@InventoryId", id);
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchIssueByInvId");
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
        protected void chkAddIssueDetails_CheckedChanged(object sender, EventArgs e)
        {
            if (chkAddIssueDetails.Checked)
            {
                dvAddIssueMasterDetails.Visible = true;
                // grdIssueDetailEntry.Visible = true;
            }
            else
            {
                dvAddIssueMasterDetails.Visible = false;
                grdIssueDetailEntry.Visible = false;
            }
        }



        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                string XMLData = CreateIssueDetailsXML();
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@CategoryId", drpCategory.SelectedItem.Value);
                sqlCmd.Parameters.AddWithValue("@SubCategoryId", drpSubCategory.SelectedItem.Value);
                sqlCmd.Parameters.AddWithValue("@InventoryName", txtInventoryName.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription1", txtInventoryDescription1.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription2", txtInventoryDescription2.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription3", txtInventoryDescription3.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription", txtInventoryDescription.Text);
                sqlCmd.Parameters.AddWithValue("@PurchasedFrom", txtPurchasedFrom.Text);
                sqlCmd.Parameters.AddWithValue("@PurchaseDate", txtPurchaseDate.Text);
                sqlCmd.Parameters.AddWithValue("@Bill_InvoiceNo", txtBill_InvoiceNo.Text);
                sqlCmd.Parameters.AddWithValue("@ItemQuantity", txtItemQuantity.Text);
                sqlCmd.Parameters.AddWithValue("@ItemRatePerUnit", txtItemRatePerUnit.Text);
                sqlCmd.Parameters.AddWithValue("@ItemTotalCost", txtItemTotalCost.Text);
                sqlCmd.Parameters.AddWithValue("@SalesTax", txtSalesTax.Text);
                sqlCmd.Parameters.AddWithValue("@TotalAmount", txtTotalAmount.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryCreatedBy", 1);//filhal otherwise from session
                sqlCmd.Parameters.AddWithValue("@InventoryCreatedOn", DateTime.Now);
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedBy", 1);//filhal otherwise from session
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedOn", DateTime.Now);
                sqlCmd.Parameters.AddWithValue("@IsConsumable", chkIsConsumable.Checked);
                sqlCmd.Parameters.AddWithValue("@InventoryRegisterNo", txtInventoryRegisterNo.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryPageNo", txtInventoryPageNo.Text);


                if (dvAddIssueMasterDetails.Visible == true && chkAddIssueDetails.Checked == true)
                {
                    sqlCmd.Parameters.AddWithValue("@ActionType", "SaveIEandIssue");
                    sqlCmd.Parameters.AddWithValue("@XmlData", XMLData);
                    //sqlCmd.Parameters.AddWithValue("@UserId", drpIssuedTo.SelectedItem.Value);
                    //sqlCmd.Parameters.AddWithValue("@IssueDate", txtIssueDate.Text);
                    //sqlCmd.Parameters.AddWithValue("@IssuedBy", 1); //filhal
                    //sqlCmd.Parameters.AddWithValue("@IssueQuantity", txtIssueQuantity.Text);
                    //sqlCmd.Parameters.AddWithValue("@IsReceived", chkIsReceived.Checked);
                    //sqlCmd.Parameters.AddWithValue("@IssuerRemarks", txtIssuerRemarks.Text);
                    //sqlCmd.Parameters.AddWithValue("@ReceiptRemarks", txtReceiptRemarks.Text);


                }
                else if (dvAddIssueMasterDetails.Visible == false && chkAddIssueDetails.Checked == false)
                {
                    sqlCmd.Parameters.AddWithValue("@ActionType", "SaveInventoryEntries");
                }
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblError.Text = "Record Saved Successfully";
                    //lblMsgSuccess.Visible = true;
                    lblError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblError.Font.Size = 16;

                    GetInventoryEntries();
                    //dvAddCategoryDetails.Visible = false;
                    dvAddIssueMasterDetails.Visible = false;
                    grdIssueDetailEntry.Visible = false;
                    dvListInventoryDetails.Visible = true;

                    clearAllFields();
                    
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

        private string CreateIssueDetailsXML()
        {
            StringBuilder sb = new StringBuilder();
            //Loop through each row of gridview
            
            foreach (GridViewRow row in grdIssueDetailEntry.Rows)
            {
                sb.Append(String.Format("<IssueDetails UserId='{0}' IssueDate='{1}' IssuedBy='{2}' IssueQuantity='{3}' IsReceived='{4}' IssuerRemarks='{5}' ReceiptRemarks='{6}'/>",
                                                        row.Cells[1].Text, row.Cells[2].Text, 1, row.Cells[3].Text, row.Cells[4].Text, row.Cells[5].Text, 
                                                        (row.Cells[4].Text == "False")?"Not Yet Recieved":row.Cells[6].Text));
            }
            //change 1 to session user ID issuedBy
            return String.Format("<ROOT>{0}</ROOT>", sb.ToString());
        }

        protected void clearAllFields()
        {
            txtReceiptRemarks.Text = string.Empty;
            drpCategory.SelectedItem.Value = "-1";
            drpSubCategory.SelectedItem.Value = "-1";
            txtInventoryName.Text = string.Empty;
            txtInventoryDescription1.Text = string.Empty;
            txtInventoryDescription2.Text = string.Empty;
            txtInventoryDescription3.Text = string.Empty;
            txtInventoryDescription.Text = string.Empty;
            txtPurchasedFrom.Text = string.Empty;
            txtPurchaseDate.Text = string.Empty;
            txtBill_InvoiceNo.Text = string.Empty;
            txtItemQuantity.Text = string.Empty;
            txtItemRatePerUnit.Text = string.Empty;
            txtItemTotalCost.Text = string.Empty;
            txtSalesTax.Text = string.Empty;
            txtTotalAmount.Text = string.Empty;
            chkIsConsumable.Checked = false;
            chkAddIssueDetails.Checked = false;
            chkIsReceived.Checked = false;
            drpIssuedTo.SelectedItem.Value = "-1";
            txtIssueDate.Text = string.Empty;
            txtIssueQuantity.Text=  string.Empty;
            txtIssuerRemarks.Text = string.Empty;
            txtReceiptRemarks.Text = string.Empty;
            txtInventoryPageNo.Text = string.Empty;
            txtInventoryRegisterNo.Text = string.Empty;
        }

        protected void grdInventoryMaster_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string inventoryId = grdInventoryMaster.DataKeys[e.Row.RowIndex].Value.ToString();
                GridView grdIssueDetailDisplay = e.Row.FindControl("grdIssueDetailDisplay") as GridView;
                dtData = new DataTable();
                dtData = FetchIssueDetails(inventoryId);
                grdIssueDetailDisplay.DataSource = dtData;
                grdIssueDetailDisplay.DataBind();
            }
        }
       
        protected void BindGrid()
        {
            grdIssueDetailEntry.DataSource = (DataTable)ViewState["IssueDetail"];
            grdIssueDetailEntry.DataBind();
        }
        
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            clearAllFields();
            CreateIssueDetailsGrid();
            //  dvAddCategoryDetails.Visible = dvSubCategory.Visible = false;
            dvListInventoryDetails.Visible = true;
        }
        //check
        protected void btnAddInventory_Click(object sender, EventArgs e)
        {
          //  lnkAddSubCategory.Text = "Add Sub-Category";
            //dvAddCategoryDetails.Visible = true;
            //dvListCategoryDetails.Visible = false;
            //CreateSubCategoryGrid();
        }

        protected void grdInventoryMaster_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            //Setting the EditIndex property to -1 to cancel the Edit mode in Gridview  
            grdInventoryMaster.EditIndex = -1;
            GetInventoryEntries();
        }

        protected void grdInventoryMaster_RowEditing(object sender, GridViewEditEventArgs e)
        {
            //NewEditIndex property used to determine the index of the row being edited.  
            grdInventoryMaster.EditIndex = e.NewEditIndex;
            GetInventoryEntries();
        }

        protected void grdInventoryMaster_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //Finding the controls from Gridview for the row which is going to update  
            Label InventoryId = grdInventoryMaster.Rows[e.RowIndex].FindControl("lblItemId") as Label;
            Label CategoryId = grdInventoryMaster.Rows[e.RowIndex].FindControl("lblCategoryId") as Label;
            TextBox InventoryName = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtInventoryName") as TextBox;
            TextBox InventoryDescription1 = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtInventoryDescription1") as TextBox;
            TextBox InventoryDescription2 = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtInventoryDescription2") as TextBox;
            TextBox InventoryDescription3 = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtInventoryDescription3") as TextBox;
            TextBox InventoryDescription = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtInventoryDescription") as TextBox;
            TextBox PurchaseDate = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtPurchaseDate") as TextBox;
            TextBox PurchasedFrom = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtPurchasedFrom") as TextBox;
            TextBox Bill_InvoiceNo = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtBill_InvoiceNo") as TextBox;
            TextBox ItemQuantity = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtItemQuantity") as TextBox;
            TextBox ItemRatePerUnit = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtItemRatePerUnit") as TextBox;
            TextBox ItemTotalCost = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtItemTotalCost") as TextBox;
            TextBox SalesTax = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtSalesTax") as TextBox;
            TextBox TotalAmount = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtTotalAmount") as TextBox;
            TextBox InventoryRegisterNo = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtInventoryRegisterNo") as TextBox;
            TextBox InventoryPageNo = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtInventoryPageNo") as TextBox;
            CheckBox IsConsumable = grdInventoryMaster.Rows[e.RowIndex].FindControl("chkIsConsumable") as CheckBox;
            //TextBox WarrantyTo = grdInventoryMaster.Rows[e.RowIndex].FindControl("txtWarrantyTo") as TextBox;

            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@InventoryId", InventoryId.Text);
                sqlCmd.Parameters.AddWithValue("@CategoryId", CategoryId.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryName", InventoryName.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription1", InventoryDescription1.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription2", InventoryDescription2.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription3", InventoryDescription3.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription", InventoryDescription.Text);
                sqlCmd.Parameters.AddWithValue("@PurchaseDate", PurchaseDate.Text);
                sqlCmd.Parameters.AddWithValue("@PurchasedFrom", PurchasedFrom.Text);
                sqlCmd.Parameters.AddWithValue("@Bill_InvoiceNo", Bill_InvoiceNo.Text);
                sqlCmd.Parameters.AddWithValue("@ItemQuantity", ItemQuantity.Text);
                sqlCmd.Parameters.AddWithValue("@ItemRatePerUnit", ItemRatePerUnit.Text);
                sqlCmd.Parameters.AddWithValue("@ItemTotalCost", ItemTotalCost.Text);
                sqlCmd.Parameters.AddWithValue("@SalesTax", SalesTax.Text);
                sqlCmd.Parameters.AddWithValue("@TotalAmount", TotalAmount.Text);
                sqlCmd.Parameters.AddWithValue("@IsConsumable", IsConsumable.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryRegisterNo", InventoryRegisterNo.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryPageNo", InventoryPageNo.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedBy", 1);//user id filhal
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedOn", DateTime.Now);
                //  sqlCmd.Parameters.AddWithValue("@WarrantyTo", WarrantyTo.Text);
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveInventoryEntries");
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
            grdInventoryMaster.EditIndex = -1;
            //Call ShowData method for displaying updated data  
            GetInventoryEntries();
        }

        #endregion
        //previous page elements

        protected void btnSubmitInventoryEntries_Click(object sender, EventArgs e)
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                //As of now put UserId =1 for Data Entry operator
                string UserId = "1";

                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveIEandIssue");
               // sqlCmd.Parameters.AddWithValue("@ItemId", drpCategory.SelectedItem.Value);
                sqlCmd.Parameters.AddWithValue("@CategoryId", drpCategory.SelectedItem.Value);
                sqlCmd.Parameters.AddWithValue("@SubCategoryId", drpSubCategory.SelectedItem.Value);
                sqlCmd.Parameters.AddWithValue("@InventoryName", txtInventoryName.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription1", txtInventoryDescription1.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription2", txtInventoryDescription2.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription3", txtInventoryDescription3.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryDescription", txtInventoryDescription.Text);
                sqlCmd.Parameters.AddWithValue("@PurchasedFrom",  txtPurchasedFrom.Text);
                sqlCmd.Parameters.AddWithValue("@PurchaseDate", txtPurchaseDate.Text);

                sqlCmd.Parameters.AddWithValue("@Bill_InvoiceNo", txtBill_InvoiceNo.Text);
                sqlCmd.Parameters.AddWithValue("@ItemQuantity", txtItemQuantity.Text);
                sqlCmd.Parameters.AddWithValue("@ItemRatePerUnit", txtItemRatePerUnit.Text);

                sqlCmd.Parameters.AddWithValue("@ItemTotalCost", txtItemTotalCost.Text);
                sqlCmd.Parameters.AddWithValue("@SalesTax", txtSalesTax.Text);
                sqlCmd.Parameters.AddWithValue("@TotalAmount", txtTotalAmount.Text);

                sqlCmd.Parameters.AddWithValue("@InventoryCreatedBy", UserId);
                sqlCmd.Parameters.AddWithValue("@InventoryCreatedOn", DateTime.Now);
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedBy", UserId);
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedOn", DateTime.Now);
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedBy", UserId);
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedOn", DateTime.Now);
                sqlCmd.Parameters.AddWithValue("@InventoryRegisterNo", txtInventoryRegisterNo.Text);
                sqlCmd.Parameters.AddWithValue("@InventoryPageNo", txtInventoryPageNo.Text);

                sqlCmd.Parameters.AddWithValue("@IsConsumable", chkIsConsumable.Checked);
                
                sqlCmd.Parameters.AddWithValue("@UserId", drpIssuedTo.SelectedItem.Value);
                sqlCmd.Parameters.AddWithValue("@IssueDate", txtIssueDate.Text);
                sqlCmd.Parameters.AddWithValue("@IssuedBy", UserId);
                sqlCmd.Parameters.AddWithValue("@IssueQuantity", txtIssueQuantity.Text);
                sqlCmd.Parameters.AddWithValue("@IsReceived", chkIsReceived.Checked);
                sqlCmd.Parameters.AddWithValue("@IssuerRemarks", txtIssuerRemarks.Text);
                sqlCmd.Parameters.AddWithValue("@ReceiptRemarks", txtReceiptRemarks.Text);

                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblError.Text = "Record Saved Successfully";
                    lblError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblError.Font.Size = 16;
                    GetInventoryEntries();
                    clearAllFields();
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

        protected void grdInventoryEntries_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdInventoryEntries.PageIndex = e.NewPageIndex;
            this.GetInventoryEntries();
        }
        protected void grdInventoryMaster_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdInventoryMaster.PageIndex = e.NewPageIndex;
            this.GetInventoryEntries();
        }

        protected void grdInventoryEntries_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header || e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[1].Attributes.Add("style", "display:none");
            }
        }
   

        //    protected void grdInventoryMaster_RowDataBound(object sender, GridViewRowEventArgs e)
        //{
        //    if (e.Row.RowType == DataControlRowType.Header || e.Row.RowType == DataControlRowType.DataRow)
        //    {
        //        e.Row.Cells[1].Attributes.Add("style", "display:none");
        //    }
        //}

        protected void chkIsReceived_CheckedChanged(object sender, EventArgs e)
        {
            txtReceiptRemarks.Visible = chkIsReceived.Checked;
        }

        protected void drpCategory_SelectedIndexChanged1(object sender, EventArgs e)
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
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchSubCatsByCatId");
                sqlCmd.Parameters.AddWithValue("@CategoryId", Int32.Parse(drpCategory.SelectedValue));
                SqlDataAdapter sqlSda = new SqlDataAdapter(sqlCmd);
                sqlSda.Fill(ds);
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    drpSubCategory.DataSource = ds.Tables[0];
                    drpSubCategory.DataTextField = "SubCategoryName";
                    drpSubCategory.DataValueField = "SubCategoryID";
                    drpSubCategory.DataBind();
                }
                else
                {
                    drpSubCategory.DataSource = ds.Tables[0];
                    drpSubCategory.DataTextField = "SubCategoryName";
                    drpSubCategory.DataValueField = "SubCategoryID";
                    drpSubCategory.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
            finally
            {
                ds.Dispose();
            }
        }


    }
}
