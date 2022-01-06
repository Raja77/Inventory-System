<%@ Page Title="View Inventory(s)" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IssueMaster.aspx.cs"
    Inherits="Inventory.IssueMaster" EnableViewState="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <asp:Label ID="lblError" runat="server" CssClass="lbl" Font-Size="14"></asp:Label>
  

    <div id="dvAddIssueMasterDetails" runat="server" visible="false">
        <div class="mb-4 row">
            <label for="txtIssuedTo" class="col-sm-3 txt"><span class="RequiredField">* </span>Issue To</label>
            <div class="col-sm-6">
                <asp:TextBox ID="txtIssuedTo" runat="server" CssClass="form-control" placeholder="Issue To (Person/Department)"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCategoryName" runat="server" CssClass="lbl" ErrorMessage="Enter Issued To"
                    ControlToValidate="txtIssuedTo" Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
        <br />
            <div class="mb-4 row">
                <label for="txtIssueDate" class="col-sm-3 txt"><span class="RequiredField">* </span>Issue Date</label>
              <div class="col-sm-4">
                                    <asp:TextBox ID="txtIssueDate" runat="server" CssClass="form-control" placeholder="dd-MMM-yyyy"></asp:TextBox>
                                </div>
                                <div class="col-sm-2">
                                    <asp:ImageButton ID="imgPopup" ImageUrl="../Images/cal.png" Width="35px" Height="35px" ImageAlign="Bottom"
                                        runat="server" />
                                    <ajaxToolkit:CalendarExtender ID="Calendar1" PopupButtonID="imgPopup" runat="server" TargetControlID="txtIssueDate"
                                        Format="dd-MMM-yyyy"></ajaxToolkit:CalendarExtender>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvIssueDate" runat="server" CssClass="lbl" ErrorMessage="Enter Issued Date"
                    ControlToValidate="txtIssueDate" Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
            </div>
        
        <div class="mb-4 row">
            <label for="txtIssueQuantity" class="col-sm-3 txt"><span class="RequiredField">* </span>Issue Quantity</label>
            <div class="col-sm-2">
                <asp:TextBox ID="txtIssueQuantity" runat="server" CssClass="form-control" placeholder="Quantity Number"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCategoryDescription" runat="server" CssClass="lbl" ErrorMessage="Enter Issue Quantity"
                    ControlToValidate="txtIssueQuantity" Display="Dynamic" ValidationGroup="valCategoryMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
      <br />
        <div class="mb-4 row">
            <label for="drpInventory" class="col-sm-3 " style="text-align: right;"><span class="RequiredField">* </span>Select Inventory:</label>
            <div class="col-sm-4">
                <asp:DropDownList ID="drpInventory" runat="server" CssClass="form-control drp">
                    <asp:ListItem Text="Select Inventory Name" Value="-1"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvdrpInventory" runat="server" CssClass="lbl" ErrorMessage="Select Inventory" InitialValue="-1"
                    ControlToValidate="drpInventory" Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
            </div>
        </div>
        <br />
        <div class="mb-4 row">
            <label for="chkSubCategory" class="col-sm-3 txt">
               Is Received
            </label>
            <div class="col-sm-4">
                <asp:CheckBox ID="chkIsReceived" runat="server" Style="margin-top: 10px;" />
            </div>
        </div>
        <br />
            <div class="mb-4 row">
                <label for="txtIssuerRemarks" class="col-sm-3 txt"><span class="RequiredField">* </span>Issuer Remarks</label>
                <div class="col-sm-4">
                    <asp:TextBox ID="txtIssuerRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" Columns="4"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvIssuerRemarks" runat="server" CssClass="lbl" ErrorMessage="Enter Issuer Remarks"
                        ControlToValidate="txtIssuerRemarks" Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
                </div>
            </div>
           <br />
           <div class="mb-4 row">
                <label for="txtReceiptRemarks" class="col-sm-3 txt"><span class="RequiredField">* </span>Receipt Remarks</label>
                <div class="col-sm-4">
                    <asp:TextBox ID="txtReceiptRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" Columns="4"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvReceiptRemarks" runat="server" CssClass="lbl" ErrorMessage="Enter Issuer Remarks"
                        ControlToValidate="txtReceiptRemarks" Display="Dynamic" ValidationGroup="valIssueMaster"></asp:RequiredFieldValidator>
                </div>
            </div>
        <br />
        <div class="mb-4 row">
            <label for="btnSubmit" class="col-sm-3 txt"></label>
            <div class="col-sm-6">
                <asp:Button ID="btnSubmit" runat="server" Text="Create Issue Details" CssClass="btn btn-primary txt" ToolTip="Click here to Submit Issue Details"
                    OnClick="btnSubmit_Click" ValidationGroup="valIssueMaster" />
            </div>
            <asp:Label ID="lblMsgSuccess" runat="server" Text="Data Saved Successfully" Visible="false"></asp:Label>
        </div>

    </div>

    <div class="mb-4 row">
        <label for="btnSubmit" class="col-sm-3">
            <h4>Check Issue Master Details</h4>
        </label>
        <div class="col-sm-9 txt">
            <asp:Button ID="btnAddIssueMaster" runat="server" Text="Add New Issue Details" OnClick="btnAddIssueMaster_Click" 
                CssClass="btn btn-primary txt" ToolTip="Click here to Add New Issue Details"
                 />
        </div>
        <asp:Label ID="Label1" runat="server" Text="Data Saved Successfully" Visible="false"></asp:Label>
    </div>
    <hr />

    <asp:GridView ID="grdIssueMaster" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped"
        AllowPaging="true" OnPageIndexChanging="grdIssueMaster_PageIndexChanging" OnRowDataBound="grdIssueMaster_RowDataBound"
        DataKeyNames="IssueId" GridLines="None" runat="server" AutoGenerateColumns="false" PageSize="5"
        OnRowCancelingEdit="grdIssueMaster_RowCancelingEdit" OnRowEditing="grdIssueMaster_RowEditing"
        OnRowUpdating="grdIssueMaster_RowUpdating">
        <HeaderStyle />
        <EmptyDataTemplate>
            <label class="lbl">No Issue Details found in our system !</label>
        </EmptyDataTemplate>
        <AlternatingRowStyle CssClass="alt" />
        <Columns>
            <asp:TemplateField HeaderText="S No." HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                <ItemTemplate>
                    <%# Container.DataItemIndex + 1 + "." %>
                    <asp:Label ID="lblCategoryId" runat="server" Text='<%#Eval("IssueId") %>' Visible="false"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Category Name">
                <ItemTemplate>
                    <asp:Label ID="lblCategoryName" runat="server" Text='<%#Eval("IssuerRemarks") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtCategoryName" runat="server" Text='<%#Eval("IssuerRemarks") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Category Description">
                <ItemTemplate>
                    <asp:Label ID="lblCategoryDescription" runat="server" Text='<%#Eval("IssuerRemarks") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtCategoryDescription" runat="server" Text='<%#Eval("IssuerRemarks") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Button ID="btn_Edit" runat="server" Text="Edit Category" CommandName="Edit" />
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:Button ID="btn_Update" runat="server" Text="Update Category" CommandName="Update" />
                    <asp:Button ID="btn_Cancel" runat="server" Text="Cancel" CommandName="Cancel" />
                </EditItemTemplate>
            </asp:TemplateField>

        </Columns>
        <PagerStyle HorizontalAlign="Right" CssClass="GridPager" />
    </asp:GridView>


</asp:Content>

