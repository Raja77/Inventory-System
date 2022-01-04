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
    public partial class ItemRegistry : Page
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

                var x = Request.Url.ToString();
                GetItemRegistryDetails();
            }
            lblError.Text = string.Empty;
        }

        protected void GetItemRegistryDetails(string sortExpression = null)
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
                        grdItemRegistry.DataSource = dv;
                    }
                    else
                    {
                        grdItemRegistry.DataSource = ds;
                    }
                    grdItemRegistry.DataBind();
                    countItemRegistry.InnerText = ds.Tables[0].Rows.Count.ToString();
                    countItemRegistry.Attributes.Add("title", "Item Registry Details");
                }
                else
                {
                    grdItemRegistry.DataSource = ds.Tables[0];
                    grdItemRegistry.DataBind();
                    countItemRegistry.InnerText = "0";
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
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchItemRegistry");
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
            txtItemName.Text = string.Empty;
            txtItemDescription.Text = string.Empty;
        }

        protected void btnSubmitItemEntries_Click(object sender, EventArgs e)
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
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveItemRegistry");
                sqlCmd.Parameters.AddWithValue("@ItemName", txtItemName.Text);
                sqlCmd.Parameters.AddWithValue("@ItemDescription", txtItemDescription.Text);
                sqlCmd.Parameters.AddWithValue("@ItemCreatedBy", "User1");
                sqlCmd.Parameters.AddWithValue("@ItemCreatedOn", DateTime.Now);
                sqlCmd.Parameters.AddWithValue("@ItemUpdatedBy", "User2");
                sqlCmd.Parameters.AddWithValue("@ItemUpdatedOn", DateTime.Now);
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblError.Text = "Record Saved Successfully";
                    lblError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblError.Font.Size = 16;
                    GetItemRegistryDetails();
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
    }
}
