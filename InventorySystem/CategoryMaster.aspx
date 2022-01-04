<%@ Page Title="View Inventory(s)" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CategoryMaster.aspx.cs"
    Inherits="Inventory.CategoryMaster" EnableViewState="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblError" runat="server" CssClass="lbl" Font-Size="14"></asp:Label>
    <div id="dvInventoryDetails" runat="server">
        <br />
        <h4>Item Registry details</h4>
        <hr />
        <p style="font-size: 18px; background-color: lightpink; color: black;">
            <strong style="font-size: 20px;">Disclamer: </strong><i>Fill the proper details.</i>
        </p>
       <div class="mb-4 row">
            <label for="txtItemName" class="col-sm-2 " style="text-align: right;"><span id="spItemName" runat="server" class="RequiredField">* </span>Item Name:</label>
            <div class="col-sm-7">
                <asp:TextBox ID="txtItemName" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvItemName" runat="server" CssClass="lbl" ErrorMessage="Enter Item Name"
                    ControlToValidate="txtItemName" Display="Dynamic" ValidationGroup="VerifyItems"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="mb-4 row">
            <label for="txtItemDescription" class="col-sm-2 " style="text-align: right;"><span id="spItemDescription" runat="server" class="RequiredField">* </span>Item Description:</label>
            <div class="col-sm-7">
                <asp:TextBox ID="txtItemDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="10" Columns="5"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvItemDescription" runat="server" CssClass="lbl" ErrorMessage="Enter Item Description"
                    ControlToValidate="txtItemDescription" Display="Dynamic" ValidationGroup="VerifyItems"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="mb-4 row">
            <label class="col-sm-3 "></label>
            <div class="col-sm-6 ">
                <asp:Button ID="btnSubmitItemEntries" runat="server" CssClass="btn" Text="Submit Details" ValidationGroup="VerifyItems" OnClick="btnSubmitItemEntries_Click" />
                <asp:Button ID="btnCancel" runat="server" CssClass="btn" Text="Cancel" OnClick="btnCancel_Click" />
            </div>
        </div>
    </div>

    <div>
         <Header>Item Registry <strong>(<span id="countItemRegistry" runat="server">0</span>)</strong></Header>
        <asp:GridView ID="grdItemRegistry" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped"
            DataKeyNames="ItemId" GridLines="None" runat="server" AutoGenerateColumns="false">
            <HeaderStyle />
            <EmptyDataTemplate>
                <label class="lbl">No Item found in the system !</label>
            </EmptyDataTemplate>
            <AlternatingRowStyle CssClass="alt" />
            <Columns>
                   <asp:TemplateField HeaderText="S No." HeaderStyle-Width="10%" HeaderStyle-HorizontalAlign="Left">
                    <ItemTemplate>
                        <%# Container.DataItemIndex + 1 + "." %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ItemName" HeaderText="Item">
                    <HeaderStyle />
                </asp:BoundField>
                <asp:TemplateField HeaderText="Item Description" HeaderStyle-CssClass="headerWidth">
                    <ItemTemplate>
                        <asp:Label ID="lblVerified" runat="server" Text='<%# Eval("ItemDescription") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

</asp:Content>

