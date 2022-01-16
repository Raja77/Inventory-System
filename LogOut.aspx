<%@ Page Title="LogOut from the Inventory System" Language="C#" AutoEventWireup="true" CodeBehind="LogOut.aspx.cs" Inherits="Inventory.LogOut" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Welcome to Inventory System _ Log Out </title>

</head>


<body>

  <form id="form1" runat="server">
    <asp:Label ID="Label1" Text="Logging Out Please Wait" runat="server" />
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:Timer ID="Timer1" runat="server" Interval="1000" OnTick="Timer1_Tick">
                </asp:Timer>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    </form>
</body>
</html>
