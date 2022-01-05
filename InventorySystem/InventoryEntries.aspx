<%@ Page Title="View Inventory(s)" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InventoryEntries.aspx.cs"
    Inherits="Inventory.InventoryEntries" EnableViewState="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblError" runat="server" CssClass="lbl" Font-Size="14"></asp:Label>
    <div id="dvInventoryDetails" runat="server">
        <br />
        <h4>Update Application/Inventory details ICSC purposes</h4>
        <hr />
        <p style="font-size: 18px; background-color: lightpink; color: black;">
            <strong style="font-size: 20px;">Disclamer: </strong><i>Fill the proper details.</i>
        </p>
    <%-- <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control drp" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
                    <asp:ListItem Text="Select Category" Value="-1"></asp:ListItem>
                 <asp:ListItem Text="Select Category 2" Value="1"></asp:ListItem>
                </asp:DropDownList>--%>

          <div class="mb-4 row">
            <label for="drpCategory" class="col-sm-2 " style="text-align: right;"><span class="RequiredField">* </span>Select Category:</label>
            <div class="col-sm-4">
                <asp:DropDownList ID="drpCategory" runat="server" AutoPostBack="true" CssClass="form-control drp" OnSelectedIndexChanged="drpCategory_SelectedIndexChanged1">
                    <asp:ListItem Text="Select Category" Value="-1"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvdrpCategory" runat="server" CssClass="lbl" ErrorMessage="Select Category" InitialValue="-1"
                    ControlToValidate="drpCategory" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="mb-4 row">
            <label for="drpSubCategory" class="col-sm-2 " style="text-align: right;"><span class="RequiredField">* </span>Select Sub Category:</label>
            <div class="col-sm-4">
                <asp:DropDownList ID="drpSubCategory" runat="server" CssClass="form-control drp">
                    <asp:ListItem Text="Select Sub Category" Value="-1"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvdrpSubCategory" runat="server" CssClass="lbl" ErrorMessage="Select Sub Category" InitialValue="-1"
                    ControlToValidate="drpSubCategory" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>

        <div class="mb-4 row">
            <label for="txtInventoryName" class="col-sm-2 " style="text-align: right;"><span id="SpanInventoryName" runat="server" class="RequiredField">* </span>Item Name:</label>
            <div class="col-sm-7">
                <asp:TextBox ID="txtInventoryName" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvtxtInventoryName" runat="server" CssClass="lbl" ErrorMessage="Enter Item Name"
                    ControlToValidate="txtInventoryName" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>
             <div class="mb-4 row">
            <label for="txtInventoryDescription" class="col-sm-2 " style="text-align: right;"><span id="spInventoryDescription" runat="server" class="RequiredField">* </span>Inventory Description:</label>
            <div class="col-sm-7">
                <asp:TextBox ID="txtInventoryDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="10" Columns="6"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvInventoryDescription" runat="server" CssClass="lbl" ErrorMessage="Enter Inventory Description"
                    ControlToValidate="txtInventoryDescription" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>
          <div class="mb-4 row">
              <label for="txtPurchaseDate" class="col-sm-2" style="text-align: right;">Purchase Date (yyyy-mm-dd):</label>
                            <div class="col-sm-2">
                                <div class="col-sm-10">
                                    <asp:TextBox ID="txtPurchaseDate" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-sm-1">
                                    <asp:ImageButton ID="imgPopup" ImageUrl="~/assets/images/cal.png" Width="35px" Height="35px" ImageAlign="Bottom"
                                        runat="server" />
                                    <ajaxToolkit:CalendarExtender ID="Calendar1" PopupButtonID="imgPopup" runat="server" TargetControlID="txtPurchaseDate"
                                        Format="dd-MMM-yyyy"></ajaxToolkit:CalendarExtender>
                                </div>
                            </div>
                 </div>

             <div class="mb-4 row">
            <label for="txtPurchasedFrom" class="col-sm-2 " style="text-align: right;"><span id="Span1" runat="server" class="RequiredField">* </span>Purchased From:</label>
            <div class="col-sm-7">
                <asp:TextBox ID="txtPurchasedFrom" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="10" Columns="6"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPurchasedFrom" runat="server" CssClass="lbl" ErrorMessage="Enter Purchased From"
                    ControlToValidate="txtPurchasedFrom" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>
           <div class="mb-4 row">
            <label for="txtBill_InvoiceNo" class="col-sm-2 " style="text-align: right;"><span id="Span2" runat="server" class="RequiredField">* </span>Bill InvoiceNo:</label>
            <div class="col-sm-7">
                <asp:TextBox ID="txtBill_InvoiceNo" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvBill_InvoiceNo" runat="server" CssClass="lbl" ErrorMessage="Enter InvoiceNo"
                    ControlToValidate="txtBill_InvoiceNo" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>
          <div class="mb-4 row">
            <label for="txtItemQuantity" class="col-sm-2 " style="text-align: right;"><span id="Span3" runat="server" class="RequiredField">* </span>Item Quantity:</label>
            <div class="col-sm-7">
                <asp:TextBox ID="txtItemQuantity" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvItemQuantity" runat="server" CssClass="lbl" ErrorMessage="Enter Item Quantity"
                    ControlToValidate="txtItemQuantity" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>
<div class="mb-4 row">
            <label for="txtItemRatePerUnit" class="col-sm-2 " style="text-align: right;"><span id="Span4" runat="server" class="RequiredField">* </span>Item Rate Per Unit:</label>
            <div class="col-sm-7">
                <asp:TextBox ID="txtItemRatePerUnit" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvItemRatePerUnit" runat="server" CssClass="lbl" ErrorMessage="Enter Item Rate Quantity"
                    ControlToValidate="txtItemRatePerUnit" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>

<%--        <div class="mb-4 row">
            <label for="txtItemRatePerUnit" class="col-sm-2 " style="text-align: right;"><span id="Span6" runat="server" class="RequiredField">* </span>Item Rate Per Unit:</label>
            <div class="col-sm-7">
                <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="lbl" ErrorMessage="Enter Item Rate Quantity"
                    ControlToValidate="txtItemRatePerUnit" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>--%>
        <div class="mb-4 row">
            <label for="txtItemTotalCost" class="col-sm-2 " style="text-align: right;"><span id="Span5" runat="server" class="RequiredField">* </span>Item Total Cost:</label>
            <div class="col-sm-7">
                <asp:TextBox ID="txtItemTotalCost" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="lbl" ErrorMessage="Enter Item Rate Quantity"
                    ControlToValidate="txtItemTotalCost" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>





























      
       
        <div class="mb-4 row">
            <label class="col-sm-3 "></label>
            <div class="col-sm-6 ">
                <asp:Button ID="btnSubmitInventoryEntries" runat="server" CssClass="btn" Text="Submit Details" ValidationGroup="VerifyInventory" 
                    OnClick="btnSubmitInventoryEntries_Click" />
                <asp:Button ID="btnCancel" runat="server" CssClass="btn" Text="Cancel" OnClick="btnCancel_Click" />
            </div>
        </div>
    </div>

        <div>
         <Header>Inventory Entries <strong>(<span id="countInventoryEntries" runat="server">0</span>)</strong></Header>
        <asp:GridView ID="grdInventoryEntries" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped"
            DataKeyNames="InventoryId" GridLines="None" runat="server" AutoGenerateColumns="true">
            <HeaderStyle />
            <EmptyDataTemplate>
                <label class="lbl">No Inventory found in the system !</label>
            </EmptyDataTemplate>
            <AlternatingRowStyle CssClass="alt" />
            <Columns>
                   <asp:TemplateField HeaderText="S No." HeaderStyle-Width="10%" HeaderStyle-HorizontalAlign="Left">
                    <ItemTemplate>
                        <%# Container.DataItemIndex + 1 + "." %>
                    </ItemTemplate>
                </asp:TemplateField>
            <%--    <asp:BoundField DataField="ItemName" HeaderText="Item">
                    <HeaderStyle />
                </asp:BoundField>
                <asp:TemplateField HeaderText="Item Description" HeaderStyle-CssClass="headerWidth">
                    <ItemTemplate>
                        <asp:Label ID="lblVerified" runat="server" Text='<%# Eval("ItemDescription") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>--%>
            </Columns>
        </asp:GridView>
    </div>

</asp:Content>

