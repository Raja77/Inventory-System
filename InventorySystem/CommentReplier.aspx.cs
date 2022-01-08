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
    public partial class CommentReplier : Page
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
                GetCommentDetails();
            }
            lblError.Text = string.Empty;
        }

        protected void GetCommentDetails()
        {
            try
            {
                ds = new DataSet();
                //dsSubCat = new DataSet();
                ds = FetchCommentDetails();
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    grdReplyMaster.DataSource = ds.Tables[0];
                    grdReplyMaster.DataBind();
                }
                else
                {
                    grdReplyMaster.DataSource = ds.Tables[0];
                    grdReplyMaster.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
        }

        private DataSet FetchCommentDetails()
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
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchCommentDetails");
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


        protected void grdReplyMaster_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdReplyMaster.PageIndex = e.NewPageIndex;
            this.GetCommentDetails();
        }

        protected void grdReplyMaster_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string commentId = grdReplyMaster.DataKeys[e.Row.RowIndex].Value.ToString();
              //  GridView grdSubCategoryMaster = e.Row.FindControl("grdSubCategoryMaster") as GridView;
                //dtData = new DataTable();
               // dtData = FetchSubCategoryMasterDetails(categoryId);
                //grdSubCategoryMaster.DataSource = dtData;
                //grdSubCategoryMaster.DataBind();
            }
        }


        protected void grdReplyMaster_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            //Setting the EditIndex property to -1 to cancel the Edit mode in Gridview  
            grdReplyMaster.EditIndex = -1;
            GetCommentDetails();
        }

        protected void grdReplyMaster_RowEditing(object sender, GridViewEditEventArgs e)
        {
            //NewEditIndex property used to determine the index of the row being edited.  
            grdReplyMaster.EditIndex = e.NewEditIndex;
            GetCommentDetails();
        }

        protected void grdReplyMaster_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //Finding the controls from Gridview for the row which is going to update  
            Label CommentId = grdReplyMaster.Rows[e.RowIndex].FindControl("lblCommentId") as Label;
            TextBox CommentReplierName = grdReplyMaster.Rows[e.RowIndex].FindControl("txtCommentReplierName") as TextBox;
            TextBox CommentReply = grdReplyMaster.Rows[e.RowIndex].FindControl("txtCommentReply") as TextBox;
        
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                dtData = new DataTable();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@CommentId", CommentId.Text);
                sqlCmd.Parameters.AddWithValue("@CommentReplierName", CommentReplierName.Text);
                sqlCmd.Parameters.AddWithValue("@CommentReply", CommentReply.Text);
                sqlCmd.Parameters.AddWithValue("@CommentRepliedOn", DateTime.Now);
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveCommentDetails");
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
            grdReplyMaster.EditIndex = -1;
            //Call ShowData method for displaying updated data  
            GetCommentDetails();
        }


        #endregion




    }
}
