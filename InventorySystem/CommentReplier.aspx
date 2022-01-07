<%@ Page Title="Comment Replier" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CommentReplier.aspx.cs"
    Inherits="Inventory.CommentReplier" EnableViewState="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <br />
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
    <hr />
    <h1>Reply to Comments</h1>
    <asp:GridView ID="grdReplyMaster" CellPadding="0" CellSpacing="0" CssClass="table table-bordered table-striped"
        AllowPaging="true" OnPageIndexChanging="grdReplyMaster_PageIndexChanging" OnRowDataBound="grdReplyMaster_RowDataBound"
        DataKeyNames="CommentId" GridLines="None" runat="server" AutoGenerateColumns="false" PageSize="5"
        OnRowCancelingEdit="grdReplyMaster_RowCancelingEdit" OnRowEditing="grdReplyMaster_RowEditing"
        OnRowUpdating="grdReplyMaster_RowUpdating">
        <HeaderStyle />
        <EmptyDataTemplate>
            <label class="lbl">No Comment Yet !</label>
        </EmptyDataTemplate>
        <AlternatingRowStyle CssClass="alt" />
        <Columns>
            <asp:TemplateField HeaderText="S No." HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                <ItemTemplate>
                    <%# Container.DataItemIndex + 1 + "." %>
                    <asp:Label ID="lblCommentId" runat="server" Text='<%#Eval("CommentId") %>' Visible="false"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Comment Date">
                <ItemTemplate>
                    <asp:Label ID="lblCommentCreatedOn" runat="server" Text='<%#Eval("CommentCreatedOn") %>'></asp:Label>
                </ItemTemplate>
             </asp:TemplateField>
                <asp:TemplateField HeaderText="Commenter Name">
                <ItemTemplate>
                    <asp:Label ID="lblCommentCreatorName" runat="server" Text='<%#Eval("CommentCreatorName") %>'></asp:Label>
                </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Comment For">
                <ItemTemplate>
                    <asp:Label ID="lblCommentPageName" runat="server" Text='<%#Eval("CommentPageName") %>'></asp:Label>
                </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Subject">
                <ItemTemplate>
                    <asp:Label ID="lblCommentSubject" runat="server" Text='<%#Eval("CommentSubject") %>'></asp:Label>
                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Comment Details">
                <ItemTemplate>
                    <asp:Label ID="lblCommentDescription" runat="server" Text='<%#Eval("CommentDescription") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Replied On">
                <ItemTemplate>
                    <asp:Label ID="lblCommentRepliedOn" runat="server" Text='<%#Eval("CommentRepliedOn") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Replier Name">
                <ItemTemplate>
                    <asp:Label ID="lbCommentReplierName" runat="server" Text='<%#Eval("CommentReplierName") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtCommentReplierName" runat="server" Text='<%#Eval("CommentReplierName") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
                       <asp:TemplateField HeaderText="Your Reply">
                <ItemTemplate>
                    <asp:Label ID="lbCommentReply" runat="server" Text='<%#Eval("CommentReply") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtCommentReply" runat="server" Text='<%#Eval("CommentReply") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Button ID="btn_Edit" runat="server" Text="Edit Reply" CommandName="Edit" />
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:Button ID="btn_Update" runat="server" Text="Update Reply" CommandName="Update" />
                    <asp:Button ID="btn_Cancel" runat="server" Text="Cancel" CommandName="Cancel" />
                </EditItemTemplate>
            </asp:TemplateField>

        </Columns>
        <PagerStyle HorizontalAlign="Right" CssClass="GridPager" />
    </asp:GridView>


</asp:Content>

