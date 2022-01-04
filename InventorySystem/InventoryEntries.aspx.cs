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
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
        SqlDataAdapter adapt;
        static int ID = 0;
        DataSet ds = null;
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
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
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
                    grdInventoryEntries.DataBind();
                    countInventoryEntries.InnerText = ds.Tables[0].Rows.Count.ToString();
                    countInventoryEntries.Attributes.Add("title", "Item Registry Details");
                }
                else
                {
                    grdInventoryEntries.DataSource = ds.Tables[0];
                    grdInventoryEntries.DataBind();
                    countInventoryEntries.InnerText = "0";
                }


                if (ds.Tables.Count > 0 && ds.Tables[1].Rows.Count > 0)
                {
                    drpItem.DataSource = ds.Tables[1];
                    drpItem.DataBind();
                    drpItem.DataTextField = "ItemName";
                    drpItem.DataValueField = "ItemID";
                    drpItem.DataBind();
                }
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
                sqlCmd.Parameters.AddWithValue("@ItemId", drpItem.SelectedItem.Value);
                sqlCmd.Parameters.AddWithValue("@InventoryName", drpItem.SelectedItem.Text);
                sqlCmd.Parameters.AddWithValue("@ItemDescription", txtInventoryDescription.Text);
                sqlCmd.Parameters.AddWithValue("@PurchasedFrom",  txtPurchasedFrom.Text);
                sqlCmd.Parameters.AddWithValue("@PurchaseDate", txtPurchaseDate.Text);

                sqlCmd.Parameters.AddWithValue("@Bill_InvoiceNo", txtBill_InvoiceNo.Text);
                sqlCmd.Parameters.AddWithValue("@ItemQuantity", txtItemQuantity.Text);
                sqlCmd.Parameters.AddWithValue("@ItemRatePerUnit", txtItemRatePerUnit.Text);

                sqlCmd.Parameters.AddWithValue("@InventoryCreatedBy", "User1");
                sqlCmd.Parameters.AddWithValue("@InventoryCreatedOn", DateTime.Now);
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedBy", "User2");
                sqlCmd.Parameters.AddWithValue("@InventoryUpdatedOn", DateTime.Now);
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

        protected void drpItem_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
