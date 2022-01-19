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
using System.Web.Security;
using System.Web.UI.HtmlControls;

namespace Inventory
{
    public partial class SiteMaster : MasterPage
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultInventoryConnection"].ConnectionString);
        public Dictionary<string, string[]> PageAccessList = new Dictionary<string, string[]>();
        DataSet ds = null;
        SqlCommand sqlCmd = null;
        protected void Page_Init(object sender, EventArgs e)
        {
            populatePageAccessList();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            populatePageAccessList();
            if (!Request.IsAuthenticated || Session["UserID"] == null)
            // This is an unauthorized, authenticated request...
            {
                string pageName = (new System.IO.FileInfo(Request.Url.AbsolutePath)).Name;
                //if (pageName != "Login" || pageName !="UnAuthorizedAccess")
                   // LogOut(); 
               // Response.Redirect("~/UnauthorizedAccess.aspx");
            }
            else
            {
                //Display LogOut button with username for succesful authentication
                lnkNavbarLoginStatus.InnerText = "Log Out " + Session["UserNameX"].ToString();
                lnkNavbarLoginStatus.HRef= "~/LogOut.aspx";
                string pageName = (new System.IO.FileInfo(Request.Url.AbsolutePath)).Name;
                string UserRole = Session["UserRoleX"].ToString();
                //redirect the user to the default page if it doesnt have access to the page
                if (hasAccess(UserRole, pageName))
                {
                    //populate Navbar pages according to access list
                    string[] AllowedPages = PageAccessList[UserRole];
                    foreach (string PageName in AllowedPages)
                    {
                        HyperLink link = new HyperLink();
                        if (PageName == "Default"
                            || PageName == "Default"
                            || PageName == "LogIn"
                            || PageName == "LogOut"
                            || PageName == "UnauthorizedAccess")
                        {
                            //nothing, dont display 
                        }
                        else //dynamically generate and display permissible page Links
                        {
                            link.ID = PageName;
                            link.NavigateUrl = "~/InventorySystem/" + PageName + ".aspx";
                            link.Text = PageName;
                            //link.Attributes["class"] = "btn btn-primary btn - lg";
                            HtmlGenericControl li = new HtmlGenericControl("li"); //Create html control <li>
                            li.Controls.Add(link); //add hyperlink to <li>
                            ulPermittedPagesList.Controls.Add(li);  //add <li> to <ul>
                        }
                    }
                }
                else
                {
                //    Response.Write("UserID not found in PageAccessList" +
                //                    " <br/><a href='~/Login.aspx'>Login Again</a>");
                //}
                //else
                //{ //Redirect to Default Page if the user doesnt have access to a specific page
                  // Response.Redirect("~/Default.aspx");
                    Response.Redirect("~/UnauthorizedAccess.aspx");
                }
            }

            if (!IsPostBack)
            {
                //GetCommentDetails();
                //if (Session["UserRoleX"].Equals("DEO1") && Session["UserNameX"].Equals("Data Entry Operator 1"))
                //{
                //    liUserMaster.Visible = liIssueDetails.Visible = liComment.Visible = false;

                //}
                //else if (Session["UserRoleX"].Equals("DEO2") && Session["UserNameX"].Equals("Data Entry Operator 2"))
                //{
                    
                //   liCategoryMaster.Visible = liInventoryEntries.Visible = liComment.Visible = false;
                //}
                //else if (Session["UserRoleX"].Equals("SuperAdmin") && Session["UserNameX"].Equals("Admin"))
                //{
                    

                //}
                //else
                //{
                //    Response.Redirect("~/UnauthorizedAccess.aspx");
                //}
            }
        }
        //This method lists out which pages are accessible to a user
        protected void populatePageAccessList()
        {
            if (PageAccessList.Count == 0)
            {
                PageAccessList.Clear();
                PageAccessList["SuperAdmin"]    = new string[] 
                                                 { "CategoryMaster",
                                                   "InventoryEntries",
                                                   "IssueMaster",
                                                   "UserMaster",
                                                   "Default",
                                                   "UnauthorizedAccess",
                                                   "LogOut"
                                                   };
                PageAccessList["DEO1"]          = new string[]
                                                  { "IssueMaster",
                                                    "Default",
                                                    "UnauthorizedAccess",
                                                    "LogOut"
                                                   };
                PageAccessList["DEO2"]          = new string[] 
                                                  { "CategoryMaster",
                                                    "InventoryEntries",
                                                     "Default",
                                                     "UnauthorizedAccess",
                                                     "LogOut"
                                                  };
                
                //PageAccessList["Others"] = new string[] { "CategoryMaster", "InventoryEntries", "IssueMaster", "UserMaster" };
            }
        }
        //this method checks whether UserId has access to PageName based on PageAccessList Dictionary
        protected bool hasAccess(string UserRole, string PageName)
        {
            string[] AllowedPages;
            if (PageAccessList.ContainsKey(UserRole))
            {
                AllowedPages = PageAccessList[UserRole];
                return AllowedPages.Contains(PageName);
            }
            else
            {
                return true;
            }
        }
      
        //unused comments sections
        protected void GetCommentDetails()
        {
            try
            {
                ds = new DataSet();
                ds = FetchCommentDetails();
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    grdComments.DataSource = ds.Tables[0];
                    grdComments.DataBind();
                }
                else
                {
                    grdComments.DataSource = ds.Tables[0];
                    grdComments.DataBind();
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

                string pageName = (new System.IO.FileInfo(Request.Url.AbsolutePath)).Name;
                ds = new DataSet();
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@CommentPageName", pageName);
                sqlCmd.Parameters.AddWithValue("@ActionType", "FetchPageComments");
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
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                string pageName = (new System.IO.FileInfo(Request.Url.AbsolutePath)).Name;
                sqlCmd = new SqlCommand("spInventories", conn);
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ActionType", "SaveCommentDetails");
                sqlCmd.Parameters.AddWithValue("@CommentCreatorName", txtCommenter.Text);
                sqlCmd.Parameters.AddWithValue("@CommentPageName", pageName);
                sqlCmd.Parameters.AddWithValue("@CommentDescription", txtCommentDescription.Text);
                sqlCmd.Parameters.AddWithValue("@CommentSubject", txtSubject.Text);
                sqlCmd.Parameters.AddWithValue("@CommentCreatedOn", DateTime.Now);
                int numRes = sqlCmd.ExecuteNonQuery();
                if (numRes > 0)
                {
                    lblCommentSubmitError.Text = "Comment Saved Successfully";
                    lblCommentSubmitError.ForeColor = System.Drawing.Color.CornflowerBlue;
                    lblCommentSubmitError.Font.Size = 16;
                    txtCommenter.Text = string.Empty;
                    txtCommentDescription.Text = string.Empty;
                    txtSubject.Text = string.Empty;
                    GetCommentDetails();
                }
                else
                    lblCommentSubmitError.Text = ("Please Try Again !!!");
            }

            catch (Exception ex)
            {
                lblCommentSubmitError.Text = ex.Message;
            }
            finally
            {
               
                sqlCmd.Dispose();
                conn.Close();
            }
        }
    }
}