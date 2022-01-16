using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inventory
{
    public partial class LogIn : Page
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultInventoryConnection"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            lblMsg.InnerText = "";
            if (!Page.IsPostBack)
            {
                if (Request.IsAuthenticated && !string.IsNullOrEmpty(Request.QueryString["ReturnUrl"]))
                    // This is an unauthorized, authenticated request...
                    Response.Redirect("~/UnauthorizedAccess.aspx");
            }
        }

        protected void btnLogIn_Click(object sender, EventArgs e)
        {
            DataSet ds = new DataSet();
            try
            {
                SqlCommand com = new SqlCommand("select * from tbuserDetails where (UserEmail='" + txtLogIn.Value + "' or" +
                    " UserName='" + txtLogIn.Value + "') " + "and [Password]='" + txtPassword.Value + "'", conn);
                SqlDataAdapter sda = new SqlDataAdapter(com);
                sda.Fill(ds);

                //if (FormsAuthentication.Authenticate(txtLogIn.Value, txtPassword.Value))
                //{
                //    FormsAuthentication.RedirectFromLoginPage(txtLogIn.Value, true);
                //}


            }
            catch (Exception ex)
            {
                if (ex.Message.ToString().Contains("DefaultConnection"))
                {
                    lblMsg.InnerText = ex.Message.ToString();
                    return;
                }
            }
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                Session["UserNameX"] = ds.Tables[0].Rows[0]["UserName"];
                //Session["Image"] = ds.Tables[0].Rows[0]["Image"];
                Session["UserID"] = ds.Tables[0].Rows[0]["UserID"];
                Session["UserRoleX"] = ds.Tables[0].Rows[0]["UserType"];



                //// Success, create non-persistent authentication cookie.
                //FormsAuthentication.SetAuthCookie(
                //        this.txtLogIn.Value.Trim(),false);

                //FormsAuthenticationTicket ticket1 =
                //   new FormsAuthenticationTicket(
                //        1,                                   // version
                //        this.txtLogIn.Value.Trim(),   // get username  from the form
                //        DateTime.Now,                        // issue time is now
                //        DateTime.Now.AddMinutes(10),         // expires in 10 minutes
                //        false,      // cookie is not persistent
                //        "SuperAdmin"                              // role assignment is stored
                //                                                  // in userData
                //        );
                //HttpCookie cookie1 = new HttpCookie(
                //  FormsAuthentication.FormsCookieName,
                //  FormsAuthentication.Encrypt(ticket1));
                //Response.Cookies.Add(cookie1);

                //// 4. Do the redirect. 
                //String returnUrl1;
                //// the login is successful
                //if (Request.QueryString["ReturnUrl"] == null)
                //{
                //    returnUrl1 = "InventorySystem/UserMaster.aspx";
                //}

                ////login not unsuccessful 
                //else
                //{
                //    returnUrl1 = Request.QueryString["ReturnUrl"];
                //}
                //Response.Redirect(returnUrl1);











                if (Session["UserRoleX"].Equals("DEO1") && Session["UserNameX"].Equals("Data Entry Operator 1"))
                {
                    Response.Redirect("~/InventorySystem/InventoryEntries.aspx");
                }
                else if (Session["UserRoleX"].Equals("DEO2") && Session["UserNameX"].Equals("Data Entry Operator 2"))
                {
                    Response.Redirect("~/InventorySystem/IssueMaster.aspx");
                }
                else if (Session["UserRoleX"].Equals("SuperAdmin") && Session["UserNameX"].Equals("Admin"))
                {
                    Response.Redirect("~/Default.aspx");
                }
                else
                {
                    lblMsg.Style.Add("color", "violet");
                    lblMsg.Style.Add("font-size", "20px");
                    lblMsg.InnerText = "You are not yet authorised user to access the system!!!";
                }
            }
            else
            {
                lblMsg.Style.Add("color", "red");
                lblMsg.Style.Add("font-size", "20px");
                lblMsg.InnerText = "Invalid User Name (Email) / Password";
            }
        }
    }
}