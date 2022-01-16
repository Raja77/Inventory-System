<%@ Page Title="LogIn to the Inventory System" Language="C#" AutoEventWireup="true" CodeBehind="LogIn.aspx.cs" Inherits="Inventory.LogIn" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Welcome to Inventory System _ Log In </title>

</head>


<body>

    <form id="frmLogIn" runat="server">

       
        <br />
        <br />
        <div class="form-group form-primary" style="padding-left:20%; padding-top:15%">
            <label class="float-label" >Your User Name (Email Address)</label>
            <br />
            <input type="text" name="email" class="form-control" placeholder="Enter User Name or Email" id="txtLogIn" style="height:32px; width:250px; float:left;"  runat="server" required="">
            <span class="form-bar"></span>

        </div>
        <br />
        <br />
        <br />
        <div class="form-group form-primary" style="padding-left:20%; ">
            <label class="float-label">Password</label>
            <br />
            <input type="password" name="password" class="form-control" id="txtPassword" placeholder="Enter Password" style="height:32px; width:250px; float:left;"  runat="server" required="">
            <span class="form-bar"></span>

        </div>
        <br />
        <br />
        <br />
        <div class="row m-t-30" style="padding-left:20%; font-size:25px;">
            <div class="col-md-12">

                <%--   <button type="button" class="btn btn-primary btn-md btn-block waves-effect waves-light text-center m-b-20">Sign in</button>--%>
                <asp:Button ID="lnkLogIn" style="font-size:25px;" runat="server" CssClass="btn btn-primary btn-md btn-block waves-effect waves-light text-center m-b-20"
                    OnClick="btnLogIn_Click" Text="Log in" ></asp:Button>
            </div>
        </div>
        <br />
        <br />
         <label id="lblMsg" runat="server" class="lbl" style="padding-left:20%; font-size:14px;"></label>
    </form>
</body>
</html>
