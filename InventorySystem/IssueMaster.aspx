<%@ Page Title="View Inventory(s)" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IssueMaster.aspx.cs"
    Inherits="Inventory.IssueMaster" EnableViewState="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <asp:Label ID="lblError" runat="server" CssClass="lbl" Font-Size="14"></asp:Label>
    <h3 style="background-color: lightgray; padding: 10px;"><strong>Issue Items to Users</strong></h3>
    <hr />
    <div id="dvAddIssueMasterDetails" runat="server">
        <%--Select Register No --%>
        <div class="mb-4 row">
            <label for="drpInventoryRegisterNo" class="col-sm-2 " style="text-align: right;">
                <span class="RequiredField">*</span>Register No:</label>
            <div class="col-sm-4">
                <asp:DropDownList ID="drpInventoryRegisterNo" runat="server" CssClass="form-control drp"
                    OnSelectedIndexChanged="drpInventoryRegisterNo_SelectedIndexChanged" AutoPostBack="true">
                    <%-- <asp:ListItem Text="Select Register No" Value="-1" Selected="True" ></asp:ListItem>--%>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvdrpInventoryRegisterNo" runat="server" CssClass="lbl"
                    ErrorMessage="Select Register No..." InitialValue="-1" ControlToValidate="drpInventoryRegisterNo"
                    Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
            </div>
            <%--Select Page No --%>
            <label for="drpInventoryPageNo" class="col-sm-2 " style="text-align: right;">
                <span class="RequiredField">*</span>Page No:</label>
            <div class="col-sm-4">
                <asp:DropDownList ID="drpInventoryPageNo" runat="server" CssClass="form-control drp"
                    OnSelectedIndexChanged="drpInventoryPageNo_SelectedIndexChanged" AutoPostBack="true">
                    <asp:ListItem Text="Select Page No" Value="-1" Selected="True"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvdrpInventoryPageNo" runat="server" CssClass="lbl"
                    ErrorMessage="Select Page No" InitialValue="-1" ControlToValidate="drpInventoryPageNo"
                    Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
        <%--Select Item --%>
        <div class="mb-4 row">
            <label for="drpInventoryId" class="col-sm-2 " style="text-align: right;">
                <span class="RequiredField">*</span>Select Item</label>
            <div class="col-sm-4">
                <asp:DropDownList ID="drpInventoryId" runat="server" CssClass="form-control drp"
                    OnSelectedIndexChanged="drpInventoryId_SelectedIndexChanged" AutoPostBack="true">
                    <asp:ListItem Text="Select Item" Value="-1" Selected="True"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvdrpInventoryId" runat="server" CssClass="lbl"
                    ErrorMessage="Select Item" InitialValue="-1" ControlToValidate="drpInventoryId"
                    Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
            </div>
            <%--Issue To --%>
            <label for="drpUserId" class="col-sm-2 " style="text-align: right;">
                <span class="RequiredField">*</span>Select whom Issue To</label>
            <div class="col-sm-4">
                <asp:DropDownList ID="drpUserId" runat="server" CssClass="form-control drp">
                    <asp:ListItem Text="Select User" Value="-1" Selected="True"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvdrpUserId" runat="server" CssClass="lbl"
                    ErrorMessage="Select whom issue to" InitialValue="-1" ControlToValidate="drpUserId"
                    Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
        <%--Issue Date--%>
        <div class="mb-4 row">
            <label for="txtIssueDate" class="col-sm-2 txt"><span class="RequiredField">* </span>Issue Date</label>
            <div class="col-sm-2">
                <asp:TextBox ID="txtIssueDate" runat="server" CssClass="form-control" placeholder="dd-MMM-yyyy"></asp:TextBox>
            </div>
            <div class="col-sm-2">
                <asp:ImageButton ID="imgPopup" ImageUrl="../Images/cal.png" Width="35px" Height="35px" ImageAlign="Bottom"
                    runat="server" />
                <ajaxToolkit:CalendarExtender ID="Calendar1" PopupButtonID="imgPopup" runat="server" TargetControlID="txtIssueDate"
                    Format="dd-MMM-yyyy"></ajaxToolkit:CalendarExtender>
                <asp:RequiredFieldValidator ID="rfvIssueDate" runat="server" CssClass="lbl" ErrorMessage="Enter Issued Date"
                    ControlToValidate="txtIssueDate" Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
            </div>
            <%-- Issue Quantity--%>
            <label for="txtIssueQuantity" class="col-sm-2 txt"><span class="RequiredField">* </span>Issue Quantity</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtIssueQuantity" runat="server" CssClass="form-control" placeholder="Quantity Number"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvIssueQuantity" runat="server" CssClass="lbl" ErrorMessage="Enter Issue Quantity"
                    ControlToValidate="txtIssueQuantity" Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revIssueQuantity" CssClass="lbl" ControlToValidate="txtIssueQuantity" runat="server"
                    ErrorMessage="Only Numbers allowed" ValidationExpression="\d+" ValidationGroup="valIssueMaster"></asp:RegularExpressionValidator>
            </div>
        </div>
        <%-- Issuer Remarks --%>
        <div class="mb-4 row">
            <label for="txtIssuerRemarks" class="col-sm-2 txt"><span class="RequiredField">* </span>Issuer Remarks</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtIssuerRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" Columns="4"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvIssuerRemarks" runat="server" CssClass="lbl" ErrorMessage="Enter Issuer Remarks"
                    ControlToValidate="txtIssuerRemarks" Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
            </div>
            <div class="col-sm-6">
                <div class="mb-4 row">
                    <%-- IsRecieved --%>
                    <label for="chkIsReceived" class="col-sm-4 txt">Is Received</label>
                    <div class="col-sm-4">
                        <asp:CheckBox ID="chkIsReceived" runat="server" Style="margin-top: 10px;" />
                    </div>
                </div>
                <div class="mb-4 row">
                    <%-- Receiver Remarks --%>
                    <label for="txtReceiptRemarks" class="col-sm-4 txt"><span class="RequiredField">* </span>Receipt Remarks</label>
                    <div class="col-sm-8">
                        <asp:TextBox ID="txtReceiptRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" Columns="4"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvReceiptRemarks" runat="server" CssClass="lbl" ErrorMessage="Enter Issuer Remarks"
                            ControlToValidate="txtReceiptRemarks" Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
        </div>
        <%-- Submit Button  --%>
        <div class="mb-4 row">
            <label for="btnSubmit" class="col-sm-4"></label>
            <label for="btnSubmit" class="col-sm-4"></label>
            <div class="col-sm-4 txt">
                <asp:Button ID="btnSubmit" runat="server" Text="Issue Item" CssClass="btn btn-primary txt" ToolTip="Click here to Submit Issue Details"
                    OnClick="btnSubmit_Click" ValidationGroup="valIssueMaster" />
            </div>
            <asp:Label ID="lblMsgSuccess" runat="server" Text="Data Saved Successfully" Visible="false"></asp:Label>
        </div>
    </div>
    <%-- Add Another Button Disabled --%>
    <%--    <div class="mb-4 row">
        <label for="btnSubmit" class="col-sm-3">
            <h4>Check Issue Master Details</h4>
        </label>
        <div class="col-sm-9 txt">
            <asp:Button ID="btnAddIssueMaster" runat="server" Text="Add New Issue Details" OnClick="btnAddIssueMaster_Click"
                CssClass="btn btn-primary txt" ToolTip="Click here to Add New Issue Details" />
        </div>
        <asp:Label ID="Label1" runat="server" Text="Data Saved Successfully" Visible="false"></asp:Label>
    </div>--%>
    <hr />
    <%--grdIssueMaster for Displaying Issue Details of the Selected Item--%>
    <div style="overflow-x: auto;">
        <asp:GridView ID="grdIssueMaster" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped"
            AllowPaging="true" OnPageIndexChanging="grdIssueMaster_PageIndexChanging" OnRowDataBound="grdIssueMaster_RowDataBound"
            DataKeyNames="IssueId" GridLines="None" runat="server" AutoGenerateColumns="false" PageSize="10"
            OnRowCancelingEdit="grdIssueMaster_RowCancelingEdit" OnRowEditing="grdIssueMaster_RowEditing"
            OnRowUpdating="grdIssueMaster_RowUpdating" OnRowDeleting="grdIssueMaster_RowDeleting">
            <HeaderStyle />
            <EmptyDataTemplate>
                <label class="lbl">No Issue Details found in our system !</label>
            </EmptyDataTemplate>
            <AlternatingRowStyle CssClass="alt" />
            <Columns>
                <asp:TemplateField HeaderText="S No." HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                    <ItemTemplate>
                        <%# Container.DataItemIndex + 1 + "." %>
                        <asp:Label ID="lblIssueId" runat="server" Text='<%#Eval("IssueId") %>' Visible="false"></asp:Label>
                        <asp:Label ID="lblInventoryId" runat="server" Text='<%#Eval("InventoryId") %>' Visible="false"></asp:Label>
                        <asp:Label ID="lblIssuedBy" runat="server" Text='<%#Eval("IssuedBy") %>' Visible="false"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Issued To">
                    <ItemTemplate>
                        <asp:Label ID="lblIssuerName" runat="server" Text='<%#Eval("IssuerName") %>'></asp:Label>
                        <asp:Label ID="lblUserId" runat="server" Text='<%#Eval("UserId") %>' Visible="false"></asp:Label>
                    </ItemTemplate>
                    <%-- <EditItemTemplate>
                    <asp:DropDownList ID="drpUserId_grid" runat="server" OnInit="drpUserId_grid_Init">
                        <asp:ListItem id="drpUserItem" runat="server" Text='<%#Eval("UserName") %>' Value='<%#Eval("UserName") %>'></asp:ListItem>
                    </asp:DropDownList>
                   <%-- <asp:TextBox ID="UserId" runat="server" Text='<%#Eval("UserId") %>'></asp:TextBox>
                </EditItemTemplate>--%>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Issue Date">
                    <ItemTemplate>
                        <asp:Label ID="lblIssueDate" runat="server" Text='<%#Eval("IssueDate", "{0: dd-MMM-yyyy}") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtIssueDate" runat="server" Text='<%#Eval("IssueDate", "{0: dd-MMM-yyyy}") %>'></asp:TextBox>
                        <div class="col-sm-2">
                            <asp:ImageButton ID="imgIssueDate" ImageUrl="../Images/cal.png" Width="35px" Height="35px" ImageAlign="Bottom" runat="server" />
                            <ajaxToolkit:CalendarExtender ID="calIssueDate" PopupButtonID="imgPopup" runat="server" TargetControlID="txtIssueDate"
                                Format="dd-MMM-yyyy"></ajaxToolkit:CalendarExtender>
                        </div>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Issue Quantity">
                    <ItemTemplate>
                        <asp:Label ID="lblIssueQuantity" runat="server" Text='<%#Eval("IssueQuantity") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtIssueQuantity" runat="server" Text='<%#Eval("IssueQuantity") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Is Received">
                    <ItemTemplate>
                        <asp:Label ID="lblIsReceived" runat="server" Text='<%#Eval("IsReceived") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:CheckBox ID="chkIsReceived" runat="server" Checked='<%#Eval("IsReceived") %>'></asp:CheckBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Issuer Remarks">
                    <ItemTemplate>
                        <asp:Label ID="lblIssuerRemarks" runat="server" Text='<%#Eval("IssuerRemarks") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtIssuerRemarks" runat="server" Text='<%#Eval("IssuerRemarks") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Receipt Remarks">
                    <ItemTemplate>
                        <asp:Label ID="lblReceiptRemarks" runat="server" Text='<%#Eval("ReceiptRemarks") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtReceiptRemarks" runat="server" Text='<%#Eval("ReceiptRemarks") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btn_Edit" runat="server" Text="Update/Delete Entry" CommandName="Edit" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:Button ID="btn_Update" runat="server" Text="Update Issue Entry" CommandName="Update" />
                        <asp:Button ID="btn_Cancel" runat="server" Text="Cancel" CommandName="Cancel" />
                        <asp:Button ID="btn_Delete" runat="server" Text="Delete Issue Entry" CommandName="Delete" />
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
            <PagerStyle HorizontalAlign="Right" CssClass="GridPager" />
        </asp:GridView>
    </div>
</asp:Content>

