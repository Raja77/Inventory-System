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
    public partial class CategoryMaster : Page
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
                GetCategoryMasterDetails();
            }
            lblError.Text = string.Empty;
        }

        protected void GetCategoryMasterDetails()
        {
            try
            {
                ds = new DataSet();
                dsSubCat = new DataSet();
                ds = FetchCategoryMasterDetails();
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    grdCategoryMaster.DataSource = ds.Tables[0];
                    grdCategoryMaster.DataBind();
                    grdSubCategoryMaster.DataSource = dsSubCat.Tables[0];
                    grdSubCategoryMaster.DataBind();
                    // countFreshApplication.InnerText = ds.Tables[0].Rows.Count.ToString();
                }
                else
                {
                    grdCategoryMaster.DataSource = ds.Tables[0];
                    grdCategoryMaster.DataBind();
                    grdSubCategoryMaster.DataSource = dsSubCat.Tables[0];
                    grdSubCategoryMaster.DataBind();
                    //countFreshApplication.InnerText = "0";
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
                //Get SubCategory Details for SubCategoryGrid
                SqlCommand sqlCmd2 = new SqlCommand("spInventories", conn);
                sqlCmd2.CommandType = CommandType.StoredProcedure;
                sqlCmd2.Parameters.AddWithValue("@ActionType", "FetchSubCategories");
                SqlDataAdapter sqlSda2 = new SqlDataAdapter(sqlCmd2);
                sqlSda2.Fill(dsSubCat);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
            finally
            {
                sqlCmd.Dispose();
                ds.Dispose();
               // dsSubCat.Dispose();
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
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@CategoryName", txtCategoryName.Text);
                sqlCmd.Parameters.AddWithValue("@CategoryDescription", txtCategoryDescription.Text);

                if (dvSubCategory.Visible==true && dvShowSubCategory.Visible == false)
                {
                    sqlCmd.Parameters.AddWithValue("@ActionType", "SaveCateNSubCat");
                    sqlCmd.Parameters.AddWithValue("@SubCategoryName", txtSubCategoryName.Text);
                    sqlCmd.Parameters.AddWithValue("@SubCategoryDescription", txtSubCategoryDescription.Text);
                }
                else if (dvSubCategory.Visible == false && dvShowSubCategory.Visible == true)
                {
                    // sqlCmd.Parameters.AddWithValue("@ActionType", "SaveCategory");
                    sqlCmd.Parameters.AddWithValue("@ActionType", "SaveCateNSubCat");
                    //if subcategory not given then enter a default subcategory with same name as the category
                    sqlCmd.Parameters.AddWithValue("@SubCategoryName", txtCategoryName.Text);
                    sqlCmd.Parameters.AddWithValue("@SubCategoryDescription", "Subcategory for "+txtCategoryDescription.Text);
                }
                    int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblError.Text = "Record Saved Successfully";
                    lblMsgSuccess.Visible = true;
                    lblError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblError.Font.Size = 16;
                    txtCategoryName.Text = string.Empty;
                    txtCategoryDescription.Text = string.Empty;
                    txtSubCategoryName.Text = string.Empty;
                    txtSubCategoryDescription.Text = string.Empty;
                    GetCategoryMasterDetails();
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

        protected void grdCategoryMaster_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdCategoryMaster.PageIndex = e.NewPageIndex;
            this.GetCategoryMasterDetails();
        }

        protected void lnkShowSubCategory_Click(object sender, EventArgs e)
        {
            dvSubCategory.Visible = true;
            dvShowSubCategory.Visible = false;
        }

        protected void lnkHideSubCategory_Click(object sender, EventArgs e)
        {
            dvSubCategory.Visible = false;
            dvShowSubCategory.Visible = true;
        }
        #endregion




    }
}
