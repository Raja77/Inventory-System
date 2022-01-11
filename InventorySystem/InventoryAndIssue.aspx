﻿<%@ Page Title="View Inventory(s)" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InventoryAndIssue.aspx.cs"
    Inherits="Inventory.InventoryAndIssue" EnableViewState="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        .ChildGrid td {
            background-color: #eee !important;
            color: black;
            font-size: 10pt;
            line-height: 200%
        }

        .ChildGrid th {
            background-color: #6C6C6C !important;
            color: White;
            font-size: 10pt;
            line-height: 200%
        }
    </style>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript">
        $("[src*=plus]").live("click", function () {
            $(this).closest("tr").after("<tr><td></td><td colspan = '999'>" + $(this).next().html() + "</td></tr>")
            $(this).attr("src", "../Images/minusIcon.png");
        });
        $("[src*=minus]").live("click", function () {
            $(this).attr("src", "../Images/plusIcon.png");
            $(this).closest("tr").next().remove();
        });

        $(".xx").on("click", function () {
            alert("The paragraph was clicked.");
        });
    </script>
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
            <br/>
            <label for="chkIsIssue" class="col-sm-4 txt">
                Do you want to add Issue details
            </label>
            <div class="col-sm-2">
                <asp:CheckBox ID="chkAddIssueDetails" runat="server" AutoPostBack="true" OnCheckedChanged="chkAddIssueDetails_CheckedChanged"/>
            </div>
        </div>
        <br />
        <div id="dvAddIssueMasterDetails" runat="server" visible="false">
        <h3 style="background-color: aqua"><strong>Issue Entries</strong></h3>
        <hr />

            <div class="mb-4 row">
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
            <%--Multiple Issue Entries Button--%>
                 <div class="col-sm-2">
                      <asp:LinkButton ID="lnkAddIssueDetail" runat="server" Text="Add Issue Detail" ValidationGroup="verifyInventory"
                OnClick="AddIssueDetail_Click" CssClass="btn btn-primary txt" ToolTip="Click here to add Issue Details(one by one) as many as you want!"/>
                 </div>
        </div>
        <%--Multiple Issue Entries SubGrid View grdIssueDetail--%>
            <div style="overflow-x: auto;">
                <asp:GridView ID="grdIssueDetailEntry" CellPadding="0" CellSpacing="0" CssClass="table" BorderColor="Aqua"
                    GridLines="None" runat="server" AutoGenerateColumns="false">
                    <HeaderStyle />
                    <EmptyDataTemplate>
                        <label class="lbl">Item has not been issued yet</label>
                    </EmptyDataTemplate>
                    <AlternatingRowStyle CssClass="alt" />
                    <Columns>
                          <asp:TemplateField HeaderText="S No." HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex + 1 + "." %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                        <asp:BoundField DataField="UserId" HeaderText="Issued To" ItemStyle-Width="120" />
                        <asp:BoundField DataField="IssueDate" HeaderText="Date of Issue" ItemStyle-Width="120" />
                        <asp:BoundField DataField="IssueQuantity" HeaderText="Quantity" ItemStyle-Width="120" />
                        <asp:BoundField DataField="IsReceived" HeaderText="Is Recieved" ItemStyle-Width="120" />
                        <asp:BoundField DataField="IssuerRemarks" HeaderText="Issuer Remarks" ItemStyle-Width="120" />
                        <asp:BoundField DataField="ReceiptRemarks" HeaderText="Receiver Remarks" ItemStyle-Width="120" />
                    </Columns>
                </asp:GridView>
            </div>
        <br />
        <%--Submit Inventory Details--%>
        <div class="mb-4 row">
            <div class="col-sm-4 txt">
                <asp:Button ID="btnSubmitInventoryEntries" runat="server" CssClass="btn btn-primary txt" Text="Submit Details" ValidationGroup="VerifyInventory"
                    OnClick="btnSubmitInventoryEntries_Click" VaidationGroup="verifyInventory" ToolTip="Click here to Submit Inventory Details" />
                <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-info txt" Text="Cancel" OnClick="btnCancel_Click" ToolTip="Click here to go to the list screen" />
            </div>
            <asp:Label ID="lblMsgSuccess" runat="server" Text="Data Saved Successfully" Visible="false"></asp:Label>
        </div>
    </div>
    <%--New Grid for Issue Details as well as Inventory--%>
    <div id="dvListInventoryDetails" runat="server">
    <div class="mb-4 row">
        <label for="btnSubmit" class="col-sm-3">
            <h4>Check Inventory Details</h4>
        </label>
        <div class="col-sm-9 txt">
            <asp:Button ID="btnAddInventory" runat="server" Text="Add New Item" CssClass="btn btn-primary txt" ToolTip="Click here to Add New Item Details"
                OnClick="btnAddInventory_Click" />
        </div>
        <asp:Label ID="Label1" runat="server" Text="Data Saved Successfully" Visible="false"></asp:Label>
    </div>
    <hr />
    <div style="overflow-x: auto;">
        <asp:GridView ID="grdInventoryMaster" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped"
            AllowPaging="true" OnPageIndexChanging="grdInventoryMaster_PageIndexChanging" OnRowDataBound="grdInventoryMaster_RowDataBound"
            DataKeyNames="InventoryId" GridLines="None" runat="server" AutoGenerateColumns="false" PageSize="5"
            OnRowCancelingEdit="grdInventoryMaster_RowCancelingEdit" OnRowEditing="grdInventoryMaster_RowEditing"
            OnRowUpdating="grdInventoryMaster_RowUpdating">
            <HeaderStyle />
            <EmptyDataTemplate>
                <label class="lbl">No Item found in our system !</label>
            </EmptyDataTemplate>
            <AlternatingRowStyle CssClass="alt" />
            <Columns>
                <%--Template Field for Issue Details--%>
                <asp:TemplateField ItemStyle-Width="10px">
                    <ItemTemplate>
                        <img alt="" style="cursor: pointer" src="../Images/plusIcon.png" />
                        <asp:Panel ID="pnlIssueDetails" runat="server" Style="display: none">
                            <asp:GridView ID="grdIssueDetailDisplay" runat="server" AutoGenerateColumns="false" DataKeyNames="IssueId"
                                CssClass="ChildGrid table table-bordered table-striped">
                                <HeaderStyle />
                                <EmptyDataTemplate>
                                    <label class="lbl">No Issue details found for this item !</label>
                                </EmptyDataTemplate>
                                <AlternatingRowStyle CssClass="alt" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S No." HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex + 1 + "." %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="UserId" HeaderText="Issued To" ItemStyle-Width="120" ><HeaderStyle /></asp:BoundField>
                                    <asp:BoundField DataField="IssueDate" HeaderText="Date of Issue" ItemStyle-Width="120" ><HeaderStyle /></asp:BoundField>
                                    <asp:BoundField DataField="IssueQuantity" HeaderText="Quantity" ItemStyle-Width="120" ><HeaderStyle /></asp:BoundField>
                                    <asp:BoundField DataField="IsReceived" HeaderText="Is Recieved" ItemStyle-Width="120" ><HeaderStyle /></asp:BoundField>
                                    <asp:BoundField DataField="IssuerRemarks" HeaderText="Issuer Remarks" ItemStyle-Width="120" ><HeaderStyle /></asp:BoundField>
                                    <asp:BoundField DataField="ReceiptRemarks" HeaderText="Receiver Remarks" ItemStyle-Width="120" ><HeaderStyle /></asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </asp:Panel>
                    </ItemTemplate>
                </asp:TemplateField>
                <%--Template Field for Item Details with Corresponding Edit Options--%>
                <asp:TemplateField HeaderText="S No." HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                    <ItemTemplate><%# Container.DataItemIndex + 1 + "." %>
                        <asp:Label ID="lblItemId" runat="server" Text='<%#Eval("InventoryId") %>' Visible="false"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Item Name">
                    <ItemTemplate><asp:Label ID="lblInventoryName" runat="server" Text='<%#Eval("InventoryName") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtInventoryName" runat="server" Text='<%#Eval("InventoryName") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                    <asp:TemplateField HeaderText="Category">
                    <ItemTemplate><asp:Label ID="lblCategoryId" runat="server" Text='<%#Eval("CategoryId") %>'></asp:Label></ItemTemplate>
                    <%--<EditItemTemplate><asp:TextBox ID="txtCategoryName" runat="server" Text='<%#Eval("CategoryName") %>'></asp:TextBox></EditItemTemplate>--%>
                </asp:TemplateField>
                    <asp:TemplateField HeaderText="Sub Category">
                    <ItemTemplate><asp:Label ID="lblSubCategoryId" runat="server" Text='<%#Eval("SubCategoryId") %>'></asp:Label></ItemTemplate>
                    <%--<EditItemTemplate><asp:TextBox ID="txtSubCategoryName" runat="server" Text='<%#Eval("SubCategoryName") %>'></asp:TextBox></EditItemTemplate>--%>
                </asp:TemplateField>
                    <asp:TemplateField HeaderText="Description">
                    <ItemTemplate><asp:Label ID="lblInventoryDescription" runat="server" Text='<%#Eval("InventoryDescription") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtInventoryDescription" runat="server" Text='<%#Eval("InventoryDescription") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                    <asp:TemplateField HeaderText="Purchase Date">
                    <ItemTemplate><asp:Label ID="lblPurchaseDate" runat="server" Text='<%#Eval("PurchaseDate") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtPurchaseDate" runat="server" Text='<%#Eval("PurchaseDate") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                    <asp:TemplateField HeaderText="Vendor">
                    <ItemTemplate><asp:Label ID="lblPurchasedFrom" runat="server" Text='<%#Eval("PurchasedFrom") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtPurchasedFrom" runat="server" Text='<%#Eval("PurchasedFrom") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                    <asp:TemplateField HeaderText="Bill No">
                    <ItemTemplate><asp:Label ID="lblBill_InvoiceNo" runat="server" Text='<%#Eval("Bill_InvoiceNo") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtBill_InvoiceNo" runat="server" Text='<%#Eval("Bill_InvoiceNo") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                    <asp:TemplateField HeaderText="Quantity">
                    <ItemTemplate><asp:Label ID="lblItemQuantity" runat="server" Text='<%#Eval("ItemQuantity") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtItemQuantity" runat="server" Text='<%#Eval("ItemQuantity") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Rate per Unit">
                    <ItemTemplate><asp:Label ID="lblItemRatePerUnit" runat="server" Text='<%#Eval("ItemRatePerUnit") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtItemRatePerUnit" runat="server" Text='<%#Eval("ItemRatePerUnit") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Total Cost">
                    <ItemTemplate><asp:Label ID="lblItemTotalCost" runat="server" Text='<%#Eval("ItemTotalCost") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtItemTotalCost" runat="server" Text='<%#Eval("ItemTotalCost") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Tax">
                    <ItemTemplate><asp:Label ID="lblSalesTax" runat="server" Text='<%#Eval("SalesTax") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtSalesTax" runat="server" Text='<%#Eval("SalesTax") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Total Amount">
                    <ItemTemplate><asp:Label ID="lblTotalAmount" runat="server" Text='<%#Eval("TotalAmount") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtTotalAmount" runat="server" Text='<%#Eval("TotalAmount") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="IsConsumable">
                    <ItemTemplate><asp:Label ID="lblIsConsumable" runat="server" Text='<%#Eval("IsConsumable") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtIsConsumable" runat="server" Text='<%#Eval("IsConsumable") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Warranty Till">
                    <ItemTemplate><asp:Label ID="lblWarrantyTo" runat="server" Text='<%#Eval("WarrantyTo") %>'></asp:Label></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtWarrantyTo" runat="server" Text='<%#Eval("WarrantyTo") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                 <%--Template Field for Edit Update Cancel--%>
                <asp:TemplateField>
                    <ItemTemplate><asp:Button ID="btn_Edit" runat="server" Text="Edit Item" CommandName="Edit" /></ItemTemplate>
                    <EditItemTemplate>
                        <asp:Button ID="btn_Update" runat="server" Text="Update Item" CommandName="Update" />
                        <asp:Button ID="btn_Cancel" runat="server" Text="Cancel" CommandName="Cancel" />
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
            <PagerStyle HorizontalAlign="Right" CssClass="GridPager" />
        </asp:GridView>
    </div>

        </div>

   <%-- Old Grid For Issue Details--%>
    <%--<div style="overflow-x:auto;">
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
    </div>--%>
</asp:Content>

