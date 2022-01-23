<%@ Page Title="LogIn to the Inventory System"  MasterPageFile="~/Site.Master"  Language="C#" AutoEventWireup="true" CodeBehind="LogIn.aspx.cs" Inherits="Inventory.LogIn" %>

<asp:Content ID="pnlLogin" runat="server" ContentPlaceHolderID="MainContent">
    <div class="jumbotron">
        <h1>INVENTORY MANAGEMENT - ICSC</h1>
        <p class="lead">Log In with Your Username/Password</p>
    </div>
     <div id="chkDetails" runat="server">
        <div class="mb-4 row">
            <label for="txtLogIn" class="col-sm-2 txt"><span class="RequiredField">* </span>User Name</label>
            <div class="col-sm-10">
                <asp:TextBox id="txtLogIn2" placeholder="Enter User Name or Email" CssClass="form-control"  runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvtxtLogIn2" runat="server" CssClass="lbl" ErrorMessage="Enter User Name"
                    ControlToValidate="txtLogIn2" Display="Dynamic" ValidationGroup="valUserMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
         <div class="mb-4 row">
              <label for="txtPassword" class="col-sm-2 txt"><span class="RequiredField">* </span>Password</label>
            <div class="col-sm-10">
                <asp:TextBox ID="txtPassword2" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvtxtPassword2" runat="server" CssClass="lbl" ErrorMessage="Enter Password"
                    ControlToValidate="txtPassword2" Display="Dynamic" ValidationGroup="valUserMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">
            <label for="btnSubmit" class="col-sm-4"></label>
            <div class="col-sm-4 txt">
                <asp:Button ID="btnSubmit" runat="server" Text="Log In" CssClass="btn btn-primary txt" ToolTip="Click here to Log In"
                    OnClick="btnLogIn_Click" ValidationGroup="valUserMaster" />
            </div>
        </div>
    </div>
       <%-- <div class="form-group form-primary" style="padding-left:20%; padding-top:15%">
            <label class="float-label" >Your User Name (Email Address)</label>
            <br />
            <input type="text" name="email" class="form-control" placeholder="Enter User Name or Email" id="txtLogIn2" style="height:32px; width:250px; float:left;"  runat="server" required="">
            <span class="form-bar"></span>
        </div>
        <br />
        <br />
        <br />
        <div class="form-group form-primary" style="padding-left:20%; ">
            <label class="float-label">Password</label>
            <br />
            <input type="password" name="password" class="form-control" id="txtPassword2" placeholder="Enter Password" style="height:32px; width:250px; float:left;"  runat="server" required="">
            <span class="form-bar"></span>
        </div>
        <br />
        <br />
        <br />
        <div class="row m-t-30" style="padding-left:20%; font-size:25px;">
            <div class="col-md-12">
                <%--   <button type="button" class="btn btn-primary btn-md btn-block waves-effect waves-light text-center m-b-20">Sign in</button>--%>
               <%-- <asp:Button ID="lnkLogIn" style="font-size:25px;" runat="server" CssClass="btn btn-primary btn-md btn-block waves-effect waves-light text-center m-b-20"
                    OnClick="btnLogIn_Click" Text="Log in" ></asp:Button>
            </div>
        </div>
        <br />--%>
        <br />
         <label id="lblMsg" runat="server" class="lbl" style="padding-left:20%; font-size:14px;"></label>
    </asp:Content>
