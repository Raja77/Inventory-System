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
using System.Web.UI.HtmlControls;

namespace Inventory
{
    public partial class UnauthorizedAccess : Page
    {
       
        protected void Page_Load(object sender, EventArgs e)
        {
            if ( Request.IsAuthenticated || Session["UserID"] != null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

    }
}