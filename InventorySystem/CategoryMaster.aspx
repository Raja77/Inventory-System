<%@ Page Title="View Inventory(s)" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CategoryMaster.aspx.cs"
    Inherits="Inventory.CategoryMaster" EnableViewState="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <br />
   
    <asp:Label ID="lblError" runat="server" CssClass="lbl" Font-Size="14"></asp:Label>
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
    <%--Buttons to Show/Hide Panels--%>
    <div class="row">
        <div class="col-md-4">
            <asp:Button ID="btnShowAddNewCategoryPanel" runat="server" Text="Add New Category"
                CssClass="btn btn-primary btn-lg" ToolTip="Click here to Add New Category Details"
                OnClick="btnShowAddNewCategoryPanel_Click"/>
        </div>
        <div class="col-md-4">
            <asp:Button ID="btnPanelShowCategoryGrid" runat="server" Text="Show All Categories"
                CssClass="btn btn-primary btn-lg" ToolTip="Click here to View Categories/Subcategories"
                OnClick="btnPanelShowCategoryGrid_Click"/>
        </div>
        <div class="col-md-4">
            <asp:Button ID="btnShowAddEditSubCategoryPanel" runat="server" Text="Add/Edit Subcategories"
                CssClass="btn btn-primary btn-lg" ToolTip="Click here to Add or Edit Subcategories"
                OnClick="btnShowAddEditSubCategoryPanel_Click"/>
        </div>
    </div>
    <%--New Category Panel--%>
    <div id="dvAddNewCategoryPanel" runat="server" visible="false" class="row">
        <div id="dvAddCategoryDetails" runat="server" visible="false">
              <h3 style="background-color: aqua"><strong>Add Category Details</strong></h3>
            <hr />
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

            <div class="mb-4 row">
                <label for="chkSubCategory" class="col-sm-3 txt">
                    Do you want to add Sub Category(ies)
                </label>
                <div class="col-sm-6">
                    <asp:CheckBox ID="chkSubCategory" runat="server" OnCheckedChanged="chkSubCategory_CheckedChanged" AutoPostBack="true" Style="margin-top: 10px;" />
                </div>
            </div>
         
            <div id="dvSubCategory" runat="server" visible="false">
                  <h3 style="background-color: aqua"><strong>Add Sub-Category Details</strong></h3>
            <hr />
                <div class="mb-4 row">
                    <label for="txtSubCategoryName" class="col-sm-2 txt"><span class="RequiredField">* </span>Sub-Category Name</label>
                    <div class="col-sm-3">
                        <asp:TextBox ID="txtSubCategoryName" runat="server" CssClass="form-control" placeholder="Sub-Category Name (like Stationary, Computer, Furniture)"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvSubCategoryName" runat="server" CssClass="lbl" ErrorMessage="Enter Sub-Category Name"
                            ControlToValidate="txtSubCategoryName" Display="Dynamic" ValidationGroup="valSubCategoryMaster"></asp:RequiredFieldValidator>
                    </div>
                      <label for="txtSubCategoryDescription" class="col-sm-2 txt"><span class="RequiredField">* </span>Sub-Category Description</label>
                    <div class="col-sm-3">
                        <asp:TextBox ID="txtSubCategoryDescription" TextMode="MultiLine" Rows="6" Columns="4" runat="server" CssClass="form-control" placeholder="Details/Description for Sub-Category"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvSubCategoryDescription" runat="server" CssClass="lbl" ErrorMessage="Enter Category Description"
                            ControlToValidate="txtSubCategoryDescription" Display="Dynamic" ValidationGroup="valSubCategoryMaster"></asp:RequiredFieldValidator>
                    </div>
                     <div class="col-sm-2">
                          <asp:LinkButton ID="lnkAddSubCategory" runat="server" Text="Add Sub-Category" ValidationGroup="valSubCategoryMaster"
                    OnClick="AddSubCategory_Click" CssClass="btn btn-primary txt" ToolTip="Click here to add sub category(one by one) as much as you can!"/>
                         </div>
                </div>
                <div style="overflow-x: auto;">
                    <asp:GridView ID="grdSubCategory" CellPadding="0" CellSpacing="0" CssClass="table" BorderColor="Aqua"
                        GridLines="None" runat="server" AutoGenerateColumns="false">
                        <HeaderStyle />
                        <EmptyDataTemplate>
                            <label class="lbl">No Sub Category has been added yet!</label>
                        </EmptyDataTemplate>
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                              <asp:TemplateField HeaderText="S No." HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex + 1 + "." %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                            <asp:BoundField DataField="SubCategoryName" HeaderText="SubCategory Name" ItemStyle-Width="120" />
                            <asp:BoundField DataField="SubCategoryDescription" HeaderText="Description" ItemStyle-Width="120" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <br />
            <div class="mb-4 row">
                <label for="btnSubmit" class="col-sm-9 txt"></label>
                <div class="col-sm-3 txt">
                       <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-info txt" ToolTip="Click here to go to the list screen"
                        OnClick="btnCancel_Click"/>
                    <asp:Button ID="btnSubmit" runat="server" Text="Create Category" CssClass="btn btn-primary txt" ToolTip="Click here to Submit Category Details"
                        OnClick="btnSubmit_Click" ValidationGroup="valCategoryMaster" />
                </div>
                <asp:Label ID="lblMsgSuccess" runat="server" Text="Data Saved Successfully" Visible="false"></asp:Label>
            </div>
        </div>
        <br />
        <div id="dvListCategoryDetails" runat="server">
        <div class="mb-4 row">
            <label for="btnSubmit" class="col-sm-3">
                <h4>Check Category Details</h4>
            </label>
            <div class="col-sm-9 txt">
                <asp:Button ID="btnAddCategory" runat="server" Text="Add New Category" CssClass="btn btn-primary txt" ToolTip="Click here to Add New Category Details"
                    OnClick="btnAddCategory_Click" Visible="false" />
            </div>
            <asp:Label ID="Label1" runat="server" Text="Data Saved Successfully" Visible="false"></asp:Label>
        </div>
            </div>
    </div>
    <%--Add/Edit Subcategory Panel--%>
    <div id="dvAddEditSubCategoryPanel" runat="server" class="row" visible="false">
        <br />
        <label for="drpPanelCategoryId" class="col-sm-2 " style="text-align: left;">
            <span class="RequiredField">*</span>Category</label>
        <div class="col-sm-10">
            <asp:DropDownList ID="drpPanelCategoryId" runat="server" CssClass="form-control drp"
                OnSelectedIndexChanged="drpPanelCategoryId_SelectedIndexChanged" AutoPostBack="true">
                <asp:ListItem Text="Select Category" Value="-1" Selected="True"></asp:ListItem>
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvdrpInventoryPageNo" runat="server" CssClass="lbl"
                ErrorMessage="Select Category" InitialValue="-1" ControlToValidate="drpPanelCategoryId"
                Display="Dynamic" ValidationGroup="valPanelSubCategory"></asp:RequiredFieldValidator>
        </div>
        <div class="row">
            <label for="txtPanelSubCategoryName" class="col-sm-2 " style="text-align: right;">
                <span class="RequiredField">*</span>Subcategory Name</label>
            <div class="col-sm-3">
                <asp:TextBox ID="txtPanelSubCategoryName" runat="server" CssClass="form-control txt" />
                <asp:RequiredFieldValidator ID="rfvtxtPanelSubCategoryName" runat="server" CssClass="lbl"
                    ErrorMessage="Enter Sub Category Name" InitialValue="-1" ControlToValidate="txtPanelSubCategoryName"
                    Display="Dynamic" ValidationGroup="valPanelSubCategory"></asp:RequiredFieldValidator>
            </div>
            <label for="txtPanelSubCategoryDescription" class="col-sm-3 " style="text-align: right;">
                <span class="RequiredField">*</span>Subcategory Description</label>
            <div class="col-sm-4">
                <asp:TextBox ID="txtPanelSubCategoryDescription" runat="server" CssClass="form-control txt" />
                <asp:RequiredFieldValidator ID="rfvtxtPanelSubCategoryDescription" runat="server" CssClass="lbl"
                    ErrorMessage="Enter Sub Category Description" InitialValue="-1" ControlToValidate="txtPanelSubCategoryDescription"
                    Display="Dynamic" ValidationGroup="valPanelSubCategory"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="row">
            <asp:Button ID="btnPanelAddSubCategory" runat="server" Text="Save Subcategory"
                CssClass="btn btn-primary btn-lg" ToolTip="Click here to Save New Subcategory"
                OnClick="btnPanelAddSubCategory_Click" />
        </div>
        <%--Grid to Display/Edit Subcategories--%>
        <div class="row">
        <asp:GridView   ID="grdPanelSubCategory" DataKeyNames="SubCategoryId" 
                        CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped"
                        AllowPaging="true" GridLines="None" runat="server" AutoGenerateColumns="false" PageSize="10"
                        OnPageIndexChanging     ="grdPanelSubCategory_PageIndexChanging" 
                        
                        OnRowCancelingEdit      ="grdPanelSubCategory_RowCancelingEdit" 
                        OnRowEditing            ="grdPanelSubCategory_RowEditing"
                        OnRowUpdating           ="grdPanelSubCategory_RowUpdating" 
                        OnRowDeleting           ="grdPanelSubCategory_RowDeleting">
        <HeaderStyle />
        <EmptyDataTemplate>
            <label class="lbl">No Sub Categories found in our system !</label>
        </EmptyDataTemplate>
        <AlternatingRowStyle CssClass="alt" />
        <Columns>
            <asp:TemplateField HeaderText="S No." HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                <ItemTemplate>
                    <%# Container.DataItemIndex + 1 + "." %>
                    <asp:Label ID="lblPanelSubCategoryId" runat="server" Text='<%#Eval("SubCategoryId") %>' Visible="false"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Sub Category Name">
                <ItemTemplate>
                    <asp:Label ID="lblPanelSubCategoryName" runat="server" Text='<%#Eval("SubCategoryName") %>'></asp:Label>
                </ItemTemplate>
               <EditItemTemplate>
                    <asp:TextBox ID="txtPanelSubCategoryName" runat="server" Text='<%#Eval("SubCategoryName") %>'/>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Sub Category Description">
                <ItemTemplate>
                    <asp:Label ID="lblPanelSubCategoryDescription" runat="server" Text='<%#Eval("SubCategoryDescription") %>'></asp:Label>
                </ItemTemplate>
               <EditItemTemplate>
                    <asp:TextBox ID="txtPanelSubCategoryDescription" runat="server" Text='<%#Eval("SubCategoryDescription") %>'/>
                </EditItemTemplate>
            </asp:TemplateField>
                        <asp:TemplateField HeaderText="Category">
                <ItemTemplate>
                    <asp:Label ID="lblPanelCategoryName" runat="server" Text='<%#Eval("CategoryName") %>'></asp:Label>
                    <asp:Label ID="lblPanelCategoryId" runat="server" Text='<%#Eval("CategoryId") %>' Visible="false"></asp:Label>
                </ItemTemplate>
            <%--   <EditItemTemplate>
                    <asp:TextBox ID="txtPanelSubCategoryDescription" runat="server" Text='<%#Eval("SubCategoryDescription") %>'/>
                </EditItemTemplate>--%>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Button ID="btn_PanelSubCategoryEdit" runat="server" Text="Update/Delete" CommandName="Edit" />
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:Button ID="btn_PanelSubCategoryUpdate" runat="server" Text="Update Issue Entry" CommandName="Update" />
                    <asp:Button ID="btn_PanelSubCategoryCancel" runat="server" Text="Cancel" CommandName="Cancel" />
                    <asp:Button ID="btn_PanelSubCategoryDelete" runat="server" Text="Delete Issue Entry" CommandName="Delete" />
                </EditItemTemplate>
            </asp:TemplateField>

        </Columns>
        <PagerStyle HorizontalAlign="Right" CssClass="GridPager" />
    </asp:GridView>
        </div>
    </div>

    <hr />
    <%--Grid to View Categories--%>
    <div id="dvGridCategory" runat="server" style="overflow-x: auto;">
            <asp:GridView ID="grdCategoryMaster" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped"
                AllowPaging="true" OnPageIndexChanging="grdCategoryMaster_PageIndexChanging" OnRowDataBound="grdCategoryMaster_RowDataBound"
                DataKeyNames="CategoryId" GridLines="None" runat="server" AutoGenerateColumns="false" PageSize="5"
                OnRowCancelingEdit="grdCategoryMaster_RowCancelingEdit" OnRowEditing="grdCategoryMaster_RowEditing"
                OnRowUpdating="grdCategoryMaster_RowUpdating">
                <HeaderStyle />
                <EmptyDataTemplate>
                    <label class="lbl">No Category found in our system !</label>
                </EmptyDataTemplate>
                <AlternatingRowStyle CssClass="alt" />
                <Columns>
                    <asp:TemplateField ItemStyle-Width="10px">
                        <ItemTemplate>
                            <img alt="" style="cursor: pointer" src="../Images/plusIcon.png" />
                            <asp:Panel ID="pnlSubCategoryMaster" runat="server" Style="display: none">
                                <asp:GridView ID="grdSubCategoryMaster" runat="server" AutoGenerateColumns="false" DataKeyNames="SubCategoryId"
                                    CssClass="ChildGrid table table-bordered table-striped">
                                    <HeaderStyle />
                                    <EmptyDataTemplate>
                                        <label class="lbl">No Sub Category found in our system !</label>
                                    </EmptyDataTemplate>
                                    <AlternatingRowStyle CssClass="alt" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S No." HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex + 1 + "." %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="SubCategoryName" HeaderText="Sub Category Name" ItemStyle-Width="20%">
                                            <HeaderStyle />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="SubCategoryDescription" HeaderText="Sub Category Description">
                                            <HeaderStyle />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                            </asp:Panel>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="S No." HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                        <ItemTemplate>
                            <%# Container.DataItemIndex + 1 + "." %>
                            <asp:Label ID="lblCategoryId" runat="server" Text='<%#Eval("CategoryId") %>' Visible="false"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Category Name">
                        <ItemTemplate>
                            <asp:Label ID="lblCategoryName" runat="server" Text='<%#Eval("CategoryName") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtCategoryName" runat="server" Text='<%#Eval("CategoryName") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Category Description">
                        <ItemTemplate>
                            <asp:Label ID="lblCategoryDescription" runat="server" Text='<%#Eval("CategoryDescription") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtCategoryDescription" runat="server" Text='<%#Eval("CategoryDescription") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>





                    <%--    <asp:BoundField DataField="CategoryName" HeaderText="Category Name" ItemStyle-Width="20%">
                    <HeaderStyle />
                </asp:BoundField>
                <asp:TemplateField HeaderText="Category Description" HeaderStyle-CssClass="headerWidth">
                    <ItemTemplate>
                        <asp:Label ID="lblCategoryDescription" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "CategoryDescription")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>--%>
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
        </div>
   
</asp:Content>

