<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UnauthorizedAccess.aspx.cs" Inherits="Inventory.UnauthorizedAccess"
    Title="Unauthorized Access" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
              <a id="lnkLogIn" href="LogIn.aspx" style="float:right;font-size:25px; padding-right:30px;" title="Click here to Login to te Inventory System" class="col-sm-6 txt btn ">Log In</a>
             <div class="mb-4 row">
            <h2 class="col-sm-6">Unauthorized Access</h2>
          
                 </div>
            <p>
                You have attempted to access a page that you are not authorized to view.
            </p>
            <p>
                If you have any questions, please contact the site administrator.
            </p>
        </div>
    </form>
</body>
</html>






<%--<asp:Content ID="Content1" ContentPlaceHolderID="MainContent"
Runat="Server">--%>

<%--</asp:Content>--%>
