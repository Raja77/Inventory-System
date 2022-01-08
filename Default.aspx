<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Inventory._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>INVENTORY MANAGEMENT - ICSC</h1>
        <p class="lead">Click on Links for Pages</p>
    </div>
    <div class="row">
        <div class="col-md-4">
            <p>
                &nbsp;<a href="InventorySystem/UserMaster.aspx" class="btn btn-primary btn-lg">User Master &raquo;</a>
                For Creating new users
            </p>
        </div>
        <div class="col-md-4">
            <p>
                &nbsp;<a href="InventorySystem/CategoryMaster.aspx" class="btn btn-primary btn-lg">Category Master &raquo;</a>
                For Creating/Editing Categories and Subcategories
            </p>
        </div>
        <div class="col-md-4">
            <p>
                &nbsp;<a href="InventorySystem/InventoryEntries.aspx" class="btn btn-primary btn-lg">Inventory Entries &raquo;</a>
                For Making Inventory Entries
            </p>
        </div>
        <div class="col-md-4">
            <p>
                &nbsp;<a href="InventorySystem/IssueMaster.aspx" class="btn btn-primary btn-lg">Issue Master &raquo;</a>
                For Viewing Issue Details
            </p>
        </div>
        </div>

    <h1>Comment Log</h1>
    <asp:Label ID="lblError" runat="server" CssClass="lbl" Font-Size="14"></asp:Label>
        <div id="chkDetails" runat="server">
            <div class="mb-4 row">
                <label for="txtCommenter" class="col-sm-3 txt"><span class="RequiredField">* </span>Your Name</label>
                <div class="col-sm-4">
                    <asp:TextBox ID="txtCommenter" runat="server" CssClass="form-control" placeholder="Commenter's Name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCommenter" runat="server" CssClass="lbl" ErrorMessage="Enter Your Name"
                        ControlToValidate="txtCommenter" Display="Dynamic" ValidationGroup="valUserMaster"></asp:RequiredFieldValidator>
                </div>
            </div>
            <br />
             <div class="mb-4 row">
                <label for="drpPageName" class="col-sm-3 txt"><span class="RequiredField">* </span>Page Regarding Which Commenting</label>
                <div class="col-sm-5">
                    <asp:DropDownList ID="drpPageName" runat="server" CssClass="form-control drp">
                        <asp:ListItem Text="Select Page Concerned" Value="-1"></asp:ListItem>
                        <asp:ListItem Text="General Comment" Value="General"></asp:ListItem>
                        <asp:ListItem Text="UserMaster.aspx" Value="UserMaster"></asp:ListItem>
                        <asp:ListItem Text="CategoryMaster.aspx" Value="CategoryMaster"></asp:ListItem>
                        <asp:ListItem Text="InventoryEntries.aspx" Value="InventoryEntries"></asp:ListItem>
                        <asp:ListItem Text="IssueMaster.aspx" Value="IssueMaster"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvdrpPageName" runat="server" CssClass="lbl" ErrorMessage="Select Page" InitialValue="-1"
                        ControlToValidate="drpPageName" Display="Dynamic" ValidationGroup="valUserMaster"></asp:RequiredFieldValidator>
                </div>
            </div>
            <br />
           
            <div class="mb-4 row">
                <label for="txtSubject" class="col-sm-3 txt"><span class="RequiredField">* </span>Comment Subject</label>
                <div class="col-sm-4">
                    <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" placeholder="Enter Comment Subject"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSubject" runat="server" CssClass="lbl" ErrorMessage="Enter Comment Subject"
                        ControlToValidate="txtSubject" Display="Dynamic" ValidationGroup="valUserMaster"></asp:RequiredFieldValidator>
                </div>
            </div>
            <br />
            <div class="mb-4 row">
            <label for="txtCommentDescription" class="col-sm-3 txt"><span class="RequiredField">* </span>Comment Description</label>
            <div class="col-sm-6">
                <asp:TextBox ID="txtCommentDescription" TextMode="MultiLine" Rows="6" Columns="4" runat="server" CssClass="form-control" placeholder="Details/Description for Comment"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCommentDescription" runat="server" CssClass="lbl" ErrorMessage="Enter Comment Description"
                    ControlToValidate="txtCommentDescription" Display="Dynamic" ValidationGroup="valUserMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
            <br />
            <div class="mb-4 row">
                <label for="btnSubmit" class="col-sm-3 txt"></label>
                  <label for="btnSubmit" class="col-sm-3 txt"></label>
                <div class="col-sm-3">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Comment" CssClass="btn btn-primary txt" ToolTip="Click here to Submit Your Comment"
                        OnClick="btnSubmit_Click" ValidationGroup="valUserMaster" />
                </div>
            </div>
        </div>
        <br />
        <h4>Comment Log</h4>
        <hr />
    <div style="overflow-x:auto;">
        <asp:GridView ID="grdComments" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped" AllowPaging="false" OnPageIndexChanging="grdComments_PageIndexChanging"
             DataKeyNames="CommentId" GridLines="None" runat="server" AutoGenerateColumns="true">
            <HeaderStyle />
            <EmptyDataTemplate>
                <label class="lbl">No Comments Yet!</label>
            </EmptyDataTemplate>
            <AlternatingRowStyle CssClass="alt" />          
        </asp:GridView>
  </div>
    </asp:Content>