<%@ Page Title="View Inventory(s)" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InventoryEntriesOld.aspx.cs"
    Inherits="Inventory.InventoryEntriesOld" EnableViewState="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblError" runat="server" CssClass="lbl" Font-Size="14"></asp:Label>
    <div id="dvInventoryDetails" runat="server">
        <br />
        <p style="font-size: 18px; background-color: lightpink; color: black;">
            <strong style="font-size: 20px;">Disclamer: </strong><i>Fill the details properly.</i>
        </p>
        <h3 style="background-color: aqua"><strong>Inventory Entries</strong></h3>
        <hr />

        <div class="mb-4 row">
            <label for="drpCategory" class="col-sm-2 " style="text-align: right;"><span class="RequiredField">* </span>Select Category:</label>
            <div class="col-sm-4">
                <asp:DropDownList ID="drpCategory" runat="server" AutoPostBack="true" CssClass="form-control drp" OnSelectedIndexChanged="drpCategory_SelectedIndexChanged1">
                    <asp:ListItem Text="Select Category" Value="-1"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvdrpCategory" runat="server" CssClass="lbl" ErrorMessage="Select Category" InitialValue="-1"
                    ControlToValidate="drpCategory" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>

            </div>
            <label for="drpSubCategory" class="col-sm-2 " style="text-align: right;"><span class="RequiredField">* </span>Select Sub Category:</label>
            <div class="col-sm-4">
                <asp:DropDownList ID="drpSubCategory" runat="server" CssClass="form-control drp">
                    <asp:ListItem Text="Select Sub Category" Value="-1"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvdrpSubCategory" runat="server" CssClass="lbl" ErrorMessage="Select Sub Category" InitialValue="-1"
                    ControlToValidate="drpSubCategory" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">
            <label for="txtInventoryName" class="col-sm-2 " style="text-align: right;"><span id="SpanInventoryName" runat="server" class="RequiredField">* </span>Item Name:</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtInventoryName" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvtxtInventoryName" runat="server" CssClass="lbl" ErrorMessage="Enter Item Name"
                    ControlToValidate="txtInventoryName" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>

            <label for="txtPurchaseDate" class="col-sm-2" style="text-align: right;">Purchase Date (dd-MMM-yyyy):</label>

            <div class="col-sm-2">
                <asp:TextBox ID="txtPurchaseDate" runat="server" CssClass="form-control" placeholder="dd-MMM-yyyy"></asp:TextBox>
            </div>
            <div class="col-sm-2">
                <asp:ImageButton ID="imgPurchaseDate" ImageUrl="../Images/cal.png" Width="35px" Height="35px" ImageAlign="Bottom"
                    runat="server" />
                <ajaxToolkit:CalendarExtender ID="calPurchaseDate" PopupButtonID="imgPopup" runat="server" TargetControlID="txtPurchaseDate"
                    Format="dd-MMM-yyyy"></ajaxToolkit:CalendarExtender>
                <asp:RequiredFieldValidator ID="rfvPurchaseDate" runat="server" CssClass="lbl" ErrorMessage="Enter Purchase Date"
                    ControlToValidate="txtPurchaseDate" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">

            <label for="txtPurchasedFrom" class="col-sm-2 " style="text-align: right;"><span id="Span1" runat="server" class="RequiredField">* </span>Purchased From:</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtPurchasedFrom" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" Columns="4"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPurchasedFrom" runat="server" CssClass="lbl" ErrorMessage="Enter Purchased From"
                    ControlToValidate="txtPurchasedFrom" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
            <label for="txtInventoryDescription" class="col-sm-2 " style="text-align: right;"><span id="spInventoryDescription" runat="server" class="RequiredField">* </span>Inventory Description:</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtInventoryDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" Columns="4"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvInventoryDescription" runat="server" CssClass="lbl" ErrorMessage="Enter Inventory Description"
                    ControlToValidate="txtInventoryDescription" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">
            <label for="txtBill_InvoiceNo" class="col-sm-2 " style="text-align: right;"><span id="Span2" runat="server" class="RequiredField">* </span>Bill InvoiceNo:</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtBill_InvoiceNo" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvBill_InvoiceNo" runat="server" CssClass="lbl" ErrorMessage="Enter InvoiceNo"
                    ControlToValidate="txtBill_InvoiceNo" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
            </div>
            <label for="txtItemQuantity" class="col-sm-2 " style="text-align: right;"><span id="Span3" runat="server" class="RequiredField">* </span>Item Quantity:</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtItemQuantity" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvItemQuantity" runat="server" CssClass="lbl" ErrorMessage="Enter Item Quantity"
                    ControlToValidate="txtItemQuantity" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revItemQuantity" CssClass="lbl" ControlToValidate="txtItemQuantity" runat="server"
                    ErrorMessage="Only Numbers allowed" ValidationExpression="\d+" ValidationGroup="VerifyInventory"></asp:RegularExpressionValidator>
            </div>
        </div>
        <br />

        <div class="mb-4 row">
            <label for="txtItemRatePerUnit" class="col-sm-2 " style="text-align: right;"><span id="Span4" runat="server" class="RequiredField">* </span>Item Rate Per Unit:</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtItemRatePerUnit" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvItemRatePerUnit" runat="server" CssClass="lbl" ErrorMessage="Enter Item Rate Quantity"
                    ControlToValidate="txtItemRatePerUnit" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revItemRatePerUnit" CssClass="lbl" ControlToValidate="txtItemRatePerUnit" runat="server"
                    ErrorMessage="Only Numbers allowed" ValidationExpression="\d+" ValidationGroup="VerifyInventory"></asp:RegularExpressionValidator>
            </div>
            <label for="txtItemTotalCost" class="col-sm-2 " style="text-align: right;"><span id="Span5" runat="server" class="RequiredField">* </span>Item Total Cost:</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtItemTotalCost" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="lbl" ErrorMessage="Enter Item Total Cost"
                    ControlToValidate="txtItemTotalCost" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revItemTotalCost" CssClass="lbl" ControlToValidate="txtItemTotalCost" runat="server"
                    ErrorMessage="Only Numbers allowed" ValidationExpression="\d+" ValidationGroup="VerifyInventory"></asp:RegularExpressionValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">
            <label for="txtSalesTax" class="col-sm-2 " style="text-align: right;"><span id="Span6" runat="server" class="RequiredField">* </span>Sales Tax:</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtSalesTax" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvSalesTax" runat="server" CssClass="lbl" ErrorMessage="Enter Sales Tax"
                    ControlToValidate="txtSalesTax" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revSalesTax" CssClass="lbl" ControlToValidate="txtSalesTax" runat="server"
                    ErrorMessage="Only Numbers allowed" ValidationExpression="\d+" ValidationGroup="VerifyInventory"></asp:RegularExpressionValidator>
            </div>
            <label for="txtTotalAmount" class="col-sm-2 " style="text-align: right;"><span id="Span7" runat="server" class="RequiredField">* </span>Total Amount:</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtTotalAmount" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvTotalAmount" runat="server" CssClass="lbl" ErrorMessage="Enter Total Amount"
                    ControlToValidate="txtTotalAmount" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revTotalAmount" CssClass="lbl" ControlToValidate="txtTotalAmount" runat="server"
                    ErrorMessage="Only Numbers allowed" ValidationExpression="\d+" ValidationGroup="VerifyInventory"></asp:RegularExpressionValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">
            <label for="chkIsConsumable" class="col-sm-2 txt">
                Is Consumable
            </label>
            <div class="col-sm-2">
                <asp:CheckBox ID="chkIsConsumable" runat="server" Style="margin-top: 10px;" />
            </div>
            <%--   <label for="chkIsIssue" class="col-sm-4 txt">
                Do you want to add Issue details
            </label>
            <div class="col-sm-2">
                <asp:CheckBox ID="chkIsIssue" runat="server" OnCheckedChanged="chkIsIssue_CheckedChanged" AutoPostBack="true" />
            </div>--%>
        </div>
        <br />

        <h3 style="background-color: aqua"><strong>Issue Entries</strong></h3>
        <hr />
        <div id="dvAddIssueMasterDetails" runat="server" visible="true">
            <div class="mb-4 row">
                <%--  <label for="txtIssuedTo" class="col-sm-2 txt"><span class="RequiredField">* </span>Issue To</label>
                <div class="col-sm-4">
                    <asp:TextBox ID="txtIssuedTo" runat="server" CssClass="form-control" placeholder="Issue To (Person/Department)"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCategoryName" runat="server" CssClass="lbl" ErrorMessage="Enter Issued To"
                        ControlToValidate="txtIssuedTo" Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
                </div>--%>
                <label for="drpIssuedTo" class="col-sm-2 " style="text-align: right;"><span class="RequiredField">* </span>Select Issue To:</label>
                <div class="col-sm-4">
                    <asp:DropDownList ID="drpIssuedTo" runat="server" CssClass="form-control drp">
                        <asp:ListItem Text="Select Issue To Person/Department" Value="-1"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvIssuedTo" runat="server" CssClass="lbl" ErrorMessage="Select Issue to whom" InitialValue="-1"
                        ControlToValidate="drpIssuedTo" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
                </div>
                <label for="txtIssueDate" class="col-sm-2 txt"><span class="RequiredField">* </span>Issue Date</label>
                <div class="col-sm-2">
                    <asp:TextBox ID="txtIssueDate" runat="server" CssClass="form-control" placeholder="dd-MMM-yyyy"></asp:TextBox>
                </div>
                <div class="col-sm-2">
                    <asp:ImageButton ID="imgIssueDate" ImageUrl="../Images/cal.png" Width="35px" Height="35px" ImageAlign="Bottom"
                        runat="server" />
                    <ajaxToolkit:CalendarExtender ID="calIssueDate" PopupButtonID="imgPopup" runat="server" TargetControlID="txtIssueDate"
                        Format="dd-MMM-yyyy"></ajaxToolkit:CalendarExtender>
                    <asp:RequiredFieldValidator ID="rfvIssueDate" runat="server" CssClass="lbl" ErrorMessage="Enter Issued Date"
                        ControlToValidate="txtIssueDate" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
                </div>

            </div>
            <br />
            <div class="mb-4 row">
                <label for="txtIssueQuantity" class="col-sm-2 txt"><span class="RequiredField">* </span>Issue Quantity</label>
                <div class="col-sm-4">
                    <asp:TextBox ID="txtIssueQuantity" runat="server" CssClass="form-control" placeholder="Quantity Number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvIssueQuantity" runat="server" CssClass="lbl" ErrorMessage="Enter Issue Quantity"
                        ControlToValidate="txtIssueQuantity" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
                     <asp:RegularExpressionValidator ID="revIssueQuantity" CssClass="lbl" ControlToValidate="txtIssueQuantity" runat="server"
                    ErrorMessage="Only Numbers allowed" ValidationExpression="\d+" ValidationGroup="VerifyInventory"></asp:RegularExpressionValidator>
                </div>
                <label for="chkSubCategory" class="col-sm-2 txt">
                    Is Received
                </label>
                <div class="col-sm-4">
                    <asp:CheckBox ID="chkIsReceived" Checked="true" runat="server" Style="margin-top: 10px;" />
                </div>
            </div>
            <%--         <br />
            <div class="mb-4 row">
                <label for="drpInventory" class="col-sm-3 " style="text-align: right;"><span class="RequiredField">* </span>Select Inventory:</label>
                <div class="col-sm-4">
                    <asp:DropDownList ID="drpInventory" runat="server" CssClass="form-control drp">
                        <asp:ListItem Text="Select Inventory Name" Value="-1"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvdrpInventory" runat="server" CssClass="lbl" ErrorMessage="Select Inventory" InitialValue="-1"
                        ControlToValidate="drpInventory" Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
                </div>
            </div>--%>
            <br />
            <div class="mb-4 row">
                <label for="txtIssuerRemarks" class="col-sm-2 txt"><span class="RequiredField">* </span>Issuer Remarks</label>
                <div class="col-sm-4">
                    <asp:TextBox ID="txtIssuerRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" Columns="4"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvIssuerRemarks" runat="server" CssClass="lbl" ErrorMessage="Enter Issuer Remarks"
                        ControlToValidate="txtIssuerRemarks" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
                </div>
                <label for="txtReceiptRemarks" class="col-sm-2 txt"><span class="RequiredField">* </span>Receipt Remarks</label>
                <div class="col-sm-4">
                    <asp:TextBox ID="txtReceiptRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" Columns="4"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvReceiptRemarks" runat="server" CssClass="lbl" ErrorMessage="Enter Issuer Remarks"
                        ControlToValidate="txtReceiptRemarks" Display="Dynamic" ValidationGroup="VerifyInventory"></asp:RequiredFieldValidator>
                </div>
            </div>
            <br />
        </div>
        <div class="mb-4 row">
            <label class="col-sm-4 "></label>
            <label class="col-sm-4 "></label>
            <div class="col-sm-4 txt">
                <asp:Button ID="btnSubmitInventoryEntries" runat="server" CssClass="btn btn-primary txt" Text="Submit Details" ValidationGroup="VerifyInventory"
                    OnClick="btnSubmitInventoryEntries_Click" />
                <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-info" Text="Cancel" OnClick="btnCancel_Click" />
            </div>
        </div>
        <br />
    </div>
    <div style="overflow-x:auto;">
        <header>Inventory Entries <strong>(<span id="countInventoryEntries" runat="server">0</span>)</strong></header>
        <asp:GridView ID="grdInventoryEntries" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped"
            DataKeyNames="InventoryId" GridLines="None" runat="server" AutoGenerateColumns="true" PageSize="5"
            AllowPaging="true" OnPageIndexChanging="grdInventoryEntries_PageIndexChanging" OnRowDataBound="grdInventoryEntries_RowDataBound">
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
            <PagerStyle HorizontalAlign="Right" CssClass="GridPager" />
        </asp:GridView>
    </div>
</asp:Content>


