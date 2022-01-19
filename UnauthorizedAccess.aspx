<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UnauthorizedAccess.aspx.cs" Inherits="Inventory.UnauthorizedAccess" %>
<%@ MasterType  virtualPath="~/Site.Master"%>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>UNAUTHORISED ACCESS</h1>
        <p class="lead">You have attempted to access a page that you are not authorized to view.</p>
    </div>
    <div class="row">
      <a href="Default.aspx" class="btn btn-primary btn-lg">Click Here to Go to the Default Page</a>
        </div>
  
    </asp:Content>