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
                ds = FetchItemRegistryDetails();
                //dsGrid also gets populated from FetchItemRegistryDetails()
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 && dsGrid.Tables.Count > 0 && dsGrid.Tables[0].Rows.Count > 0)
                {
                    if (sortExpression != null)
                    {
                        DataView dv = dsGrid.Tables[0].AsDataView();
                        this.SortDirection = this.SortDirection == "ASC" ? "DESC" : "ASC";

                        dv.Sort = sortExpression + " " + this.SortDirection;
                        grdInventoryEntries.DataSource = dv;
                    }
                    else
                    {
                        grdInventoryEntries.DataSource = dsGrid;
                    }
                    grdInventoryEntries.DataBind();
                    countInventoryEntries.InnerText = ds.Tables[0].Rows.Count.ToString();
                    countInventoryEntries.Attributes.Add("title", "Item Registry Details");
                }
                else
                {
                    grdInventoryEntries.DataSource = dsGrid.Tables[0];
                    grdInventoryEntries.DataBind();
                    countInventoryEntries.InnerText = "0";
                }


                if (ds.Tables.Count > 0 && ds.Tables[1].Rows.Count > 0)
                {
                    drpCategory.DataSource = ds.Tables[1];
                    drpCategory.DataBind();
                    drpCategory.DataTextField = "CategoryName";
                    drpCategory.DataValueField = "CategoryID";
                    drpCategory.DataBind();
                }
                drpCategory_SelectedIndexChanged1(null, null);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
        }
        private DataSet FetchItemRegistryDetails()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                ds = new DataSet();
                dsGrid = new DataSet();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchInventoryEntries");
                SqlDataAdapter sqlSda = new SqlDataAdapter(sqlCmd);
                sqlSda.Fill(ds);

                //Fetch special for display in Grid
                SqlCommand sqlCmdGrid = new SqlCommand("spInventories", conn);
                sqlCmdGrid.CommandType = CommandType.StoredProcedure;
                sqlCmdGrid.Parameters.AddWithValue("@ActionType", "FetchInventoryForGrid");
                SqlDataAdapter sqlSdaGrid = new SqlDataAdapter(sqlCmdGrid);
                sqlSdaGrid.Fill(dsGrid);
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
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveInventoryEntries");
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

                sqlCmd.Parameters.AddWithValue("@InventoryCreatedBy", "User1");
                sqlCmd.Parameters.AddWithValue("@InventoryCreatedOn", DateTime.Now);
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedBy", "User2");
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedOn", DateTime.Now);

                sqlCmd.Parameters.AddWithValue("@IsConsumable", chkIsConsumable.Checked);
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

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
