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
using System.Text;

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
            if (!Request.IsAuthenticated || Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            if (!IsPostBack)
            {
                GetCategoryMasterDetails();
                CreateSubCategoryGrid();
            }

            lblError.Text = string.Empty;
        }

        protected void GetCategoryMasterDetails()
        {
            try
            {
                ds = new DataSet();
                //dsSubCat = new DataSet();
                ds = FetchCategoryMasterDetails();
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    grdCategoryMaster.DataSource = ds.Tables[0];
                    grdCategoryMaster.DataBind();
                    //grdSubCategoryMaster.DataSource = dsSubCat.Tables[0];
                    //grdSubCategoryMaster.DataBind();
                    // countFreshApplication.InnerText = ds.Tables[0].Rows.Count.ToString();
                }
                else
                {
                    grdCategoryMaster.DataSource = ds.Tables[0];
                    grdCategoryMaster.DataBind();
                    //grdSubCategoryMaster.DataSource = dsSubCat.Tables[0];
                    //grdSubCategoryMaster.DataBind();
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

        private DataTable FetchSubCategoryMasterDetails(string id)
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
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchSubCategories");
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
                string XMLData = CreateSubCategoryXML();
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

        protected void grdCategoryMaster_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdCategoryMaster.PageIndex = e.NewPageIndex;
            this.GetCategoryMasterDetails();
        }

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

        protected void chkSubCategory_CheckedChanged(object sender, EventArgs e)
        {
            if (chkSubCategory.Checked)
                dvSubCategory.Visible = true;
            else
                dvSubCategory.Visible = false;
        }

        protected void grdCategoryMaster_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            //Setting the EditIndex property to -1 to cancel the Edit mode in Gridview  
            grdCategoryMaster.EditIndex = -1;
            GetCategoryMasterDetails();
        }

        protected void grdCategoryMaster_RowEditing(object sender, GridViewEditEventArgs e)
        {
            //NewEditIndex property used to determine the index of the row being edited.  
            grdCategoryMaster.EditIndex = e.NewEditIndex;
            GetCategoryMasterDetails();
        }

        protected void grdCategoryMaster_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //Finding the controls from Gridview for the row which is going to update  
            Label categoryId = grdCategoryMaster.Rows[e.RowIndex].FindControl("lblCategoryId") as Label;
            TextBox categoryName = grdCategoryMaster.Rows[e.RowIndex].FindControl("txtCategoryName") as TextBox;
            TextBox categoryDescription = grdCategoryMaster.Rows[e.RowIndex].FindControl("txtCategoryDescription") as TextBox;

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
            grdCategoryMaster.EditIndex = -1;
            //Call ShowData method for displaying updated data  
            GetCategoryMasterDetails();
        }

        private string CreateSubCategoryXML()
        {
            StringBuilder sb = new StringBuilder();
            //Loop through each row of gridview
            foreach (GridViewRow row in grdSubCategory.Rows)
            {
                string subCategoryName = row.Cells[1].Text;
                string subCategoryDescription = row.Cells[2].Text;
                sb.Append(String.Format("<SubCategory SubCategoryName='{0}' SubCategoryDescription='{1}'/>",
                    subCategoryName, subCategoryDescription));
            }
            return String.Format("<ROOT>{0}</ROOT>", sb.ToString());
        }

        protected void BindGrid()
        {
            grdSubCategory.DataSource = (DataTable)ViewState["SubCategory"];
            grdSubCategory.DataBind();
        }

        protected void AddSubCategory_Click(object sender, EventArgs e)
        {
            //  AddNewRecordRowToGrid();
            DataTable dt = (DataTable)ViewState["SubCategory"];
            dt.Rows.Add(txtSubCategoryName.Text.Trim(), txtSubCategoryDescription.Text.Trim());
            ViewState["SubCategory"] = dt;
            if (dt.Rows.Count > 0)
            {
                lnkAddSubCategory.Text = "Add one more Sub Category";
            }
            this.BindGrid();
            txtSubCategoryName.Text = string.Empty;
            txtSubCategoryDescription.Text = string.Empty;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            txtCategoryName.Text = txtCategoryDescription.Text = txtSubCategoryName.Text = txtSubCategoryDescription.Text = string.Empty;
            chkSubCategory.Checked = false;
            CreateSubCategoryGrid();
            dvAddCategoryDetails.Visible = dvSubCategory.Visible = false;
            dvListCategoryDetails.Visible = true;
        }

        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            lnkAddSubCategory.Text = "Add Sub-Category";
            dvAddCategoryDetails.Visible = true;
            dvListCategoryDetails.Visible = false;
            CreateSubCategoryGrid();
        }

        protected void btnShowAddNewCategoryPanel_Click(object sender, EventArgs e)
        {
            dvAddNewCategoryPanel.Visible = true;
            dvAddEditSubCategoryPanel.Visible = false;
            lnkAddSubCategory.Text = "Add Sub-Category";
            dvAddCategoryDetails.Visible = true;
            dvListCategoryDetails.Visible = true;
            CreateSubCategoryGrid();
            grdCategoryMaster.Visible = true;
            // dvAddCategoryDetails.Visible = dvSubCategory.Visible = false;
            //dvListCategoryDetails.Visible = true;
        }

        protected void btnShowAddEditSubCategoryPanel_Click(object sender, EventArgs e)
        {
            dvAddNewCategoryPanel.Visible = dvGridCategory.Visible = false;
            dvAddEditSubCategoryPanel.Visible = true;
            PopulateControl("drpPanelCategoryId");

        }

        protected void PopulateControl(string controlName)
        {
            try
            {
                ds = new DataSet();
                    if (conn.State == ConnectionState.Closed)
                    {
                        conn.Open();
                    }
                    ds = new DataSet();
                    sqlCmd = new SqlCommand("spInventories", conn);
                    sqlCmd.CommandType = CommandType.StoredProcedure;
                    sqlCmd.Parameters.AddWithValue("@CategoryId", drpPanelCategoryId.SelectedValue);
                    if (controlName == "drpPanelCategoryId")
                    {
                        sqlCmd.Parameters.AddWithValue("@ActionType", "FetchCategories");
                    }
                    else if (controlName == "grdPanelSubCategory")
                    {
                        sqlCmd.Parameters.AddWithValue("@ActionType", "FetchSubCategories");
                    }
                    SqlDataAdapter sqlSda = new SqlDataAdapter(sqlCmd);
                    sqlSda.Fill(ds);
                    if (ds.Tables.Count > 0)
                    {
                        switch (controlName)
                        {
                            case "drpPanelCategoryId":
                                drpPanelCategoryId.DataSource = ds.Tables[0];
                                drpPanelCategoryId.DataTextField = "CategoryName";
                                drpPanelCategoryId.DataValueField = "CategoryId";
                                drpPanelCategoryId.DataBind();
                                ListItem li = new ListItem("Select Category", "-1");
                                li.Selected = true;
                                drpPanelCategoryId.Items.Add(li);
                                break;
                            case "grdPanelSubCategory":
                                grdPanelSubCategory.DataSource = ds.Tables[0];
                                grdPanelSubCategory.DataBind();
                                break;

                            default:
                                {
                                    grdPanelSubCategory.DataSource = ds.Tables[0];
                                    grdPanelSubCategory.DataBind();
                                }
                                break;
                        }
                    }
                    else
                    {
                        grdPanelSubCategory.DataSource = ds.Tables[0];
                        grdPanelSubCategory.DataBind();
                    }
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
        }


        protected void drpPanelCategoryId_SelectedIndexChanged(object sender, EventArgs e)
        {
            PopulateControl("grdPanelSubCategory");
        }

        protected void btnPanelAddSubCategory_Click(object sender, EventArgs e)
        {
            try
            {
                ds = new DataSet();
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                ds = new DataSet();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@CategoryId", drpPanelCategoryId.SelectedValue);
                sqlCmd.Parameters.AddWithValue("@SubCategoryName", txtPanelSubCategoryName.Text);
                sqlCmd.Parameters.AddWithValue("@SubCategoryDescription", txtPanelSubCategoryDescription.Text);
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveUpdSubCat");
                sqlCmd.Parameters.AddWithValue("@SubActionType", "Insert");
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                    {
                    lblError.Text = "Record Saved Successfully";
                    txtPanelSubCategoryName.Text = string.Empty;
                    txtPanelSubCategoryDescription.Text = string.Empty;
                    PopulateControl("grdPanelSubCategory");
                    }
                }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
            finally
            {
                ds.Dispose();
               // dtData.Dispose();
                sqlCmd.Dispose();
                conn.Close();
            }
        }

        protected void grdPanelSubCategory_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdPanelSubCategory.PageIndex = e.NewPageIndex;
            PopulateControl("grdPanelSubCategory");
        }

        protected void grdPanelSubCategory_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            //Setting the EditIndex property to -1 to cancel the Edit mode in Gridview  
            grdPanelSubCategory.EditIndex = -1;
            PopulateControl("grdPanelSubCategory");
        }

        protected void grdPanelSubCategory_RowEditing(object sender, GridViewEditEventArgs e)
        {
            //NewEditIndex property used to determine the index of the row being edited.  
            grdPanelSubCategory.EditIndex = e.NewEditIndex;
            PopulateControl("grdPanelSubCategory");
        }

        protected void grdPanelSubCategory_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

            //Finding the controls from Gridview for the row which is going to update  
            Label   LblPanelSubCategoryId = grdPanelSubCategory.Rows[e.RowIndex].FindControl("lblPanelSubCategoryId") as Label;
            TextBox TxtPanelSubCategoryName = grdPanelSubCategory.Rows[e.RowIndex].FindControl("txtPanelSubCategoryName") as TextBox;
            TextBox TxtPanelSubCategoryDescription = grdPanelSubCategory.Rows[e.RowIndex].FindControl("txtPanelSubCategoryDescription") as TextBox;
            Label   LblPanelCategoryId = grdPanelSubCategory.Rows[e.RowIndex].FindControl("lblPanelCategoryId") as Label;
            
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
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveUpdSubCat");
                sqlCmd.Parameters.AddWithValue("@SubActionType", "Update");
                sqlCmd.Parameters.AddWithValue("@SubCategoryId", LblPanelSubCategoryId.Text);
                sqlCmd.Parameters.AddWithValue("@SubCategoryName", TxtPanelSubCategoryName.Text);
                sqlCmd.Parameters.AddWithValue("@SubCategoryDescription", TxtPanelSubCategoryDescription.Text);
                sqlCmd.Parameters.AddWithValue("@CategoryId", LblPanelCategoryId.Text);
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
            grdPanelSubCategory.EditIndex = -1;
            //Call ShowData method for displaying updated data  
            PopulateControl("grdPanelSubCategory");
        }

        protected void grdPanelSubCategory_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                
                Label LblPanelSubCategoryId = grdPanelSubCategory.Rows[e.RowIndex].FindControl("lblPanelSubCategoryId") as Label;
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ActionType", "DeleteSubCategory");
                sqlCmd.Parameters.AddWithValue("@SubCategoryId", LblPanelSubCategoryId.Text);

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
            grdPanelSubCategory.EditIndex = -1;
            // //Call ShowData method for displaying updated data  
            PopulateControl("grdPanelSubCategory");
        }

        protected void btnPanelShowCategoryGrid_Click(object sender, EventArgs e)
        {
            dvGridCategory.Visible = true;
        }

        protected void CreateSubCategoryGrid()
        {
            DataTable dt = new DataTable();
            dt.Columns.AddRange(new DataColumn[2] { new DataColumn("SubCategoryName"), new DataColumn("SubCategoryDescription") });
            ViewState["SubCategory"] = dt;
            this.BindGrid();
        }
        #endregion
    }
}
