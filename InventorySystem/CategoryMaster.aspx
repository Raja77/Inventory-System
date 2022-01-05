<%@ Page Title="View Inventory(s)" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CategoryMaster.aspx.cs"
    Inherits="Inventory.CategoryMaster" EnableViewState="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <asp:Label ID="lblError" runat="server" CssClass="lbl" Font-Size="14"></asp:Label>

    <div id="chkDetails" runat="server">
        <div class="mb-4 row">
            <label for="txtCategoryName" class="col-sm-3 txt"><span class="RequiredField">* </span>Category Name</label>
            <div class="col-sm-6">
                <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" placeholder="Category Name (like Stationary, Computer, Furniture)"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCategoryName" runat="server" CssClass="lbl" ErrorMessage="Enter Category Name"
                    ControlToValidate="txtCategoryName" Display="Dynamic" ValidationGroup="valCategoryMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">
            <label for="txtCategoryDescription" class="col-sm-3 txt"><span class="RequiredField">* </span>Category Description</label>
            <div class="col-sm-6">
                <asp:TextBox ID="txtCategoryDescription" TextMode="MultiLine" Rows="6" Columns="4" runat="server" CssClass="form-control" placeholder="Details/Description for Category"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCategoryDescription" runat="server" CssClass="lbl" ErrorMessage="Enter Category Description"
                    ControlToValidate="txtCategoryDescription" Display="Dynamic" ValidationGroup="valCategoryMaster"></asp:RequiredFieldValidator>
                 </div>
        </div>
        <div class="mb-4 row" id="dvShowSubCategory" runat="server">
           <asp:LinkButton ID="lnkShowSubCategory" runat="server" Text="Add Sub Category" OnClick="lnkShowSubCategory_Click"></asp:LinkButton>
        </div>
         <div id="dvSubCategory" runat="server" visible="false">
          <div class="mb-4 row">
           <asp:LinkButton ID="lnkHideSubCategory" runat="server" Text="Hide Sub Category" OnClick="lnkHideSubCategory_Click"></asp:LinkButton>
        </div>
        <div class="mb-4 row">
            <label for="txtSubCategoryName" class="col-sm-3 txt"><span class="RequiredField">* </span>Sub-Category Name</label>
            <div class="col-sm-6">
                <asp:TextBox ID="txtSubCategoryName" runat="server" CssClass="form-control" placeholder="Sub-Category Name (like Stationary, Computer, Furniture)"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvSubCategoryName" runat="server" CssClass="lbl" ErrorMessage="Enter Sub-Category Name"
                    ControlToValidate="txtSubCategoryName" Display="Dynamic" ValidationGroup="valCategoryMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">
            <label for="txtSubCategoryDescription" class="col-sm-3 txt"><span class="RequiredField">* </span>Sub-Category Description</label>
            <div class="col-sm-6">
                <asp:TextBox ID="txtSubCategoryDescription" TextMode="MultiLine" Rows="6" Columns="4" runat="server" CssClass="form-control" placeholder="Details/Description for Sub-Category"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvSubCategoryDescription" runat="server" CssClass="lbl" ErrorMessage="Enter Category Description"
                    ControlToValidate="txtSubCategoryDescription" Display="Dynamic" ValidationGroup="valCategoryMaster"></asp:RequiredFieldValidator>
                 </div>
        </div>
             </div>
<%--        <br />
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
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvdrpUserType" runat="server" CssClass="lbl" ErrorMessage="Select User/Role Type" InitialValue="-1"
                    ControlToValidate="drpUserType" Display="Dynamic" ValidationGroup="valCategoryMaster"></asp:RequiredFieldValidator>
            </div>
        </div>--%>
        <br />
        <div class="mb-4 row">
            <label for="btnSubmit" class="col-sm-3 txt"></label>
              <label for="btnSubmit" class="col-sm-3 txt"></label>
            <div class="col-sm-3">
                <asp:Button ID="btnSubmit" runat="server" Text="Create Category" CssClass="btn btn-primary txt" ToolTip="Click here to Submit Category Details"
                    OnClick="btnSubmit_Click" ValidationGroup="valCategoryMaster" />
            </div>
            <asp:Label ID="lblMsgSuccess" runat="server" Text="Data Saved Successfully" Visible="false"></asp:Label>
        </div>
    </div>
    <br />
    <h4>Check Category Details</h4>
    <hr />
    <asp:GridView ID="grdCategoryMaster" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped" AllowPaging="true" OnPageIndexChanging="grdCategoryMaster_PageIndexChanging"
         DataKeyNames="CategoryId" GridLines="None" runat="server" AutoGenerateColumns="false" PageSize="5">
        <HeaderStyle />
        <EmptyDataTemplate>
            <label class="lbl">No Category found in our system !</label>
        </EmptyDataTemplate>
        <AlternatingRowStyle CssClass="alt" />
        <Columns>
            <asp:BoundField DataField="CategoryName" HeaderText="Category Name">
                <HeaderStyle />
            </asp:BoundField>
            <asp:TemplateField HeaderText="Category Description" HeaderStyle-CssClass="headerWidth">
                <ItemTemplate>
                    <asp:Label ID="lblCategoryDescription" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "CategoryDescription")%>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
           <%-- <asp:BoundField DataField="UserType" HeaderText="User Type">
                <HeaderStyle />
            </asp:BoundField>--%>
        </Columns>
         <PagerStyle HorizontalAlign="Right" CssClass="GridPager" />
    </asp:GridView>
    <h4>Sub Category Details</h4>
    <hr />
     <asp:GridView ID="grdSubCategoryMaster" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped" AllowPaging="true" OnPageIndexChanging="grdCategoryMaster_PageIndexChanging"
         DataKeyNames="SubCategoryId" GridLines="None" runat="server" AutoGenerateColumns="false" PageSize="5">
        <HeaderStyle />
        <EmptyDataTemplate>
            <label class="lbl">No Sub Category found in our system !</label>
        </EmptyDataTemplate>
        <AlternatingRowStyle CssClass="alt" />
        <Columns>
            <asp:BoundField DataField="CategoryName" HeaderText="Category Name">
                <HeaderStyle />
            </asp:BoundField>
            <asp:BoundField DataField="CategoryDescription" HeaderText="Category Description">
                <HeaderStyle />
            </asp:BoundField>
            <asp:BoundField DataField="SubCategoryName" HeaderText="Sub Category Name">
                <HeaderStyle />
            </asp:BoundField>
            <asp:BoundField DataField="SubCategoryDescription" HeaderText="Sub Category Description">
                <HeaderStyle />
            </asp:BoundField>
        </Columns>
         <PagerStyle HorizontalAlign="Right" CssClass="GridPager" />
    </asp:GridView>

</asp:Content>

