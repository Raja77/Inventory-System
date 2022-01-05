<%@ Page Title="User Master Screen" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserMaster.aspx.cs"
    Inherits="Inventory.UserMaster" EnableViewState="true" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <asp:Label ID="lblError" runat="server" CssClass="lbl" Font-Size="14"></asp:Label>

    <div id="chkDetails" runat="server">
        <div class="mb-4 row">
            <label for="txtUserName" class="col-sm-3 txt"><span class="RequiredField">* </span>User Name</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control" placeholder="User Name (Person, Department)"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUserName" runat="server" CssClass="lbl" ErrorMessage="Enter User Name"
                    ControlToValidate="txtUserName" Display="Dynamic" ValidationGroup="valUserMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">
            <label for="txtUserEmail" class="col-sm-3 txt"><span class="RequiredField">* </span>User Email</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtUserEmail" runat="server" CssClass="form-control" placeholder="Email (User/Department Email)"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUserEmail" runat="server" CssClass="lbl" ErrorMessage="Enter User Email"
                    ControlToValidate="txtUserEmail" Display="Dynamic" ValidationGroup="valUserMaster"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ControlToValidate="txtUserEmail" CssClass="lbl" runat="server" Display="Dynamic"
                    ErrorMessage="Enter valid Email" ValidationExpression="^[a-z0-9][-a-z0-9._]+@([-a-z0-9]+[.])+[a-z]{2,5}$" ValidationGroup="valUserMaster"></asp:RegularExpressionValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">
            <label for="drpUserType" class="col-sm-3 txt"><span class="RequiredField">* </span>Select User/Role Type</label>
            <div class="col-sm-5">
                <asp:DropDownList ID="drpUserType" runat="server" CssClass="form-control drp">
                    <asp:ListItem Text="Select User/Role Type" Value="-1"></asp:ListItem>
                    <asp:ListItem Text="Principal" Value="Principal"></asp:ListItem>
                    <asp:ListItem Text="Department HOD" Value="DepartmentHOD"></asp:ListItem>
                    <asp:ListItem Text="Department Staff Member" Value="DepartmentStaffMember"></asp:ListItem>
                    <asp:ListItem Text="Non Teaching Staff Member" Value="NonTeachingStaffMember"></asp:ListItem>
                    <asp:ListItem Text="Local Fund Employee" Value="LFE"></asp:ListItem>
                    <asp:ListItem Text="Data Entry Operator" Value="DEO"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvdrpUserType" runat="server" CssClass="lbl" ErrorMessage="Select User/Role Type" InitialValue="-1"
                    ControlToValidate="drpUserType" Display="Dynamic" ValidationGroup="valUserMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">
            <label for="btnSubmit" class="col-sm-3 txt"></label>
              <label for="btnSubmit" class="col-sm-3 txt"></label>
            <div class="col-sm-3">
                <asp:Button ID="btnSubmit" runat="server" Text="Create User" CssClass="btn btn-primary txt" ToolTip="Click here to Submit User Details"
                    OnClick="btnSubmit_Click" ValidationGroup="valUserMaster" />
            </div>
        </div>
    </div>
    <br />
    <h4>Check User Details</h4>
    <hr />
    <asp:GridView ID="grdUserMaster" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped" AllowPaging="true" OnPageIndexChanging="grdUserMaster_PageIndexChanging"
         DataKeyNames="UserId" GridLines="None" runat="server" AutoGenerateColumns="false" PageSize="5">
        <HeaderStyle />
        <EmptyDataTemplate>
            <label class="lbl">No User found in our system !</label>
        </EmptyDataTemplate>
        <AlternatingRowStyle CssClass="alt" />
        <Columns>
            <asp:BoundField DataField="UserName" HeaderText="User Name">
                <HeaderStyle />
            </asp:BoundField>
            <asp:TemplateField HeaderText="UserEmail" HeaderStyle-CssClass="headerWidth">
                <ItemTemplate>
                    <asp:Label ID="lblUserEmail" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "UserEmail")%>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="UserType" HeaderText="User Type">
                <HeaderStyle />
            </asp:BoundField>
        </Columns>
         <PagerStyle HorizontalAlign="Right" CssClass="GridPager" />
    </asp:GridView>
  
</asp:Content>

