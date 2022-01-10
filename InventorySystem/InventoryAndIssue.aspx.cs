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
using System.Net.Mail;
using System.Text;

namespace Inventory
{
    public partial class InventoryAndIssue : Page
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
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
                {
                    if (sortExpression != null)
                    {
                        DataView dv = ds.Tables[0].AsDataView();
                        this.SortDirection = this.SortDirection == "ASC" ? "DESC" : "ASC";

                        dv.Sort = sortExpression + " " + this.SortDirection;
                        grdInventoryEntries.DataSource = dv;
                    }
                    else
                    {
                        grdInventoryEntries.DataSource = ds;
                    }
                    countInventoryEntries.InnerText = ds.Tables[0].Rows.Count.ToString();
                    countInventoryEntries.Attributes.Add("title", "Inventory Details");
                    grdInventoryEntries.DataBind();
              
                }
                else
                {
                    grdInventoryEntries.DataSource = dsGrid.Tables[0];
                    grdInventoryEntries.DataBind();
                    countInventoryEntries.InnerText = "0";
                }

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
            ViewState["IssueDetails"] = dt;
            if (dt.Rows.Count > 0)
            {
                lnkAddIssueDetail.Text = "Add Another Issue Detail";
            }
            this.BindGrid();
            drpIssuedTo.SelectedValue = "-1";
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
            ViewState["IssueDetails"] = dt;
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
                dvAddIssueMasterDetails.Visible = true;
            else
                dvAddIssueMasterDetails.Visible = false;
        }

        //check
        private string CreateIssueDetailsXML()
        {
            StringBuilder sb = new StringBuilder();
            //Loop through each row of gridview
            foreach (GridViewRow row in grdIssueDetailDisplay.Rows)
            {
                string subCategoryName = row.Cells[1].Text;
                string subCategoryDescription = row.Cells[2].Text;
                sb.Append(String.Format("<SubCategory SubCategoryName='{0}' SubCategoryDescription='{1}'/>",
                    subCategoryName, subCategoryDescription));
            }
            return String.Format("<ROOT>{0}</ROOT>", sb.ToString());
        }
        //for saving
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
                sqlCmd.Parameters.AddWithValue("@CategoryName", txtCategoryName.Text);
                sqlCmd.Parameters.AddWithValue("@CategoryDescription", txtCategoryDescription.Text);

                if (dvSubCategory.Visible == true && chkSubCategory.Checked == true)
                {
                    sqlCmd.Parameters.AddWithValue("@ActionType", "SaveCateNSubCat");
                    sqlCmd.Parameters.AddWithValue("@SubCategoryName", txtSubCategoryName.Text);
                    sqlCmd.Parameters.AddWithValue("@SubCategoryDescription", txtSubCategoryDescription.Text);
                    sqlCmd.Parameters.AddWithValue("@XmlData", XMLData);
                }
                else if (dvSubCategory.Visible == false && chkSubCategory.Checked == false)
                {
                    sqlCmd.Parameters.AddWithValue("@ActionType", "SaveCategory");
                }
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblError.Text = "Record Saved Successfully";
                    //lblMsgSuccess.Visible = true;
                    lblError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblError.Font.Size = 16;

                    GetCategoryMasterDetails();
                    dvAddCategoryDetails.Visible = false;
                    dvSubCategory.Visible = false;
                    dvListCategoryDetails.Visible = true;

                    txtCategoryName.Text = string.Empty;
                    txtCategoryDescription.Text = string.Empty;
                    txtSubCategoryName.Text = string.Empty;
                    txtSubCategoryDescription.Text = string.Empty;
                    chkSubCategory.Checked = false;
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
        //check
        protected void grdCategoryMaster_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string categoryId = grdCategoryMaster.DataKeys[e.Row.RowIndex].Value.ToString();
                GridView grdSubCategoryMaster = e.Row.FindControl("grdSubCategoryMaster") as GridView;
                dtData = new DataTable();
                dtData = FetchSubCategoryMasterDetails(categoryId);
                grdSubCategoryMaster.DataSource = dtData;
                grdSubCategoryMaster.DataBind();
            }
        }
       
        //check
        protected void BindGrid()
        {
            grdSubCategory.DataSource = (DataTable)ViewState["SubCategory"];
            grdSubCategory.DataBind();
        }
        //check
        
        //check
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            txtCategoryName.Text = txtCategoryDescription.Text = txtSubCategoryName.Text = txtSubCategoryDescription.Text = string.Empty;
            chkSubCategory.Checked = false;
            CreateSubCategoryGrid();
            dvAddCategoryDetails.Visible = dvSubCategory.Visible = false;
            dvListCategoryDetails.Visible = true;
        }
        //check
        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            lnkAddSubCategory.Text = "Add Sub-Category";
            dvAddCategoryDetails.Visible = true;
            dvListCategoryDetails.Visible = false;
            CreateSubCategoryGrid();
        }


        #endregion
        //previous page elements
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            txtInventoryDescription.Text = string.Empty;
        }
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

        protected void grdInventoryEntries_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header || e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[1].Attributes.Add("style", "display:none");
            }
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
