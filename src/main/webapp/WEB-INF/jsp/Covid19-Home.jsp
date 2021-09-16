<%@page import="com.va.UserBean"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.sql.Timestamp"%>

<jsp:useBean id="UsrBean" scope="session" class="com.va.UserBean" />
<jsp:useBean id="randomized" scope="session" class="java.lang.String" />

<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="css/bootstrap-datepicker.css">
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/bootstrap-datepicker.js"></script>
<style type="text/css">
input.MyButton {
	width: 300px;
	padding: 20px;
	font-weight: bold;
	font-size: 150%;
	background: #3366CC;
	color: #FFFFFF;
	cursor: pointer;
	border: 1px solid #999999;
	border-radius: 10px;
	-webkit-box-shadow: 6px 6px 5px #999999;
	-moz-box-shadow: 6px 6px 5px #999999;
	box-shaddow: 6px 6px 5px;
	#999999;
}

input.MyButton:hover {
	color: #FFFF00;
	background: #3366CC;
	border: 1px solid #A3A3A3;
	-webkit-box-shadow: 2px 2px 5px #666666;
	-moz-box-shadow: 2px 2px 5px #666666;
	box-shaddow: 2px 2px 5px;
	#666666;
}

.form-group-header {
	margin-left: auto;
	height: 30px;
}

.panel-heading {
	background-color: royalblue !important
}

.panel-heading1 {
	background-color: white !important
}

.panel-body {
	background-color: steelblue !important
}

.panel-body1 {
	background-color: white !important
}

.form-group label, .form-group input {
	display: inline-block;
}
</style>
<script type="text/javascript">

$(document).ready(function() {
	$('#dateOfBirthId').datepicker({
		 format: "dd-mm-yyyy",
		 endDate: '+0d'
	});
});

function addHyphen (element) {
		 let ele = document.getElementById(element.id).value;
         var val = ele.replace(/\D/g, '');
         var newVal = '';
         if(val.length > 4) {
            ele = val;
         }
         if((val.length > 3) && (val.length < 6)) {
            newVal += val.substr(0, 3) + '-';
            val = val.substr(3);
         }
         if (val.length > 5) {
            newVal += val.substr(0, 3) + '-';
            newVal += val.substr(3, 2) + '-';
            val = val.substr(5);
          }
          newVal += val;
          ele = newVal.substring(0, 11);
          document.getElementById(element.id).value = ele;
       }

</script>


<title>Covid19-Trial Randomization</title>

</head>
<body>
	<%
String path = request.getContextPath();
UserBean userBean = (UserBean) session.getAttribute("UsrBean");
String firstName = userBean.getFirstName();
String lastName = userBean.getLastName();
String ssn = userBean.getSsn();
String dateOfBirth = userBean.getDateOfBirth();
String site = userBean.getSite();
int randomId = userBean.getRandomNumber();
String treatmentValue = userBean.getTreatmentValue();
Timestamp randomNoGenTimestamp = userBean.getRandomizedDateTime();
String randomizedResult = (String)session.getAttribute("randomized");


 %>
	<br>
	<div class="container-fluid">
		<div class="panel panel-success">
			<b><font color="black"
				style="padding-right: 300px; font-family: sans-serif;">Welcome!!
			</font> </b>
			<div class="panel-heading" align="center">
				<h4>
					<b><font color="white"
						style="padding-right: 300px; font-family: sans-serif;">Covid19-Trial
							Randomization </font> </b>
				</h4>
			</div>
			<div class="panel-heading1" align="center"></div>

			<div class="panel-body" align="center">
				<div class="panel-body1" align="center">
					<br>

					<form name="home" id="homeformId" method="post"
						action="Covid_HomeServlet" class="form-horizontal">
						<table
							style="height: 550px; align: center; border-collapse: collapse;"
							width="95%" cellpadding="0" cellspacing="0">

							<tr class="form-group">
								<td align="left" width="300px" style="padding-top: 10px;" nowrap><b><font
										color="black" style="font-family: sans-serif;">First Name:
									</font></b></td>
								<td class="col-sm-4" style="padding-top: 10px;" align="left">
									<font size="4"><font color="blue"> <% if(randomId!=0 && randomizedResult=="randomized"){ 
								  %> <input type="text" class="form-control" name="firstName"
											value="<%=firstName%>" size="40" height="10px" /> <%}else{
										%> <input type="text" class="form-control" name="firstName"
											size="40" height="10px" /> <%} %>
									</font></font><br>
								</td>
							</tr>
							<tr class="form-group">
								<td align="left" nowrap><b><font color="black"
										style="font-family: sans-serif;">Last Name: </font></b></td>
								<td class="col-sm-4" align="left"><font size="4"> <font
										color="blue"> <% if(randomId!=0 && randomizedResult=="randomized"){
											%> <input type="text" class="form-control" name="lastName"
											value="<%=lastName%>" size="40" height="10px"
											required="required" /> <%}else{
											%> <input type="text" class="form-control" name="lastName"
											size="40" height="10px" required="required" /> <%} %>
									</font></font><br></td>
							</tr>
							<tr class="form-group">
								<td align="left" nowrap><b><font color="black"
										style="font-family: sans-serif;">SSN Number: </font></b></td>
								<td class="col-sm-4" align="left"><font size="4"> <font
										color="blue"> <% if(randomId!=0 && randomizedResult=="randomized"){
											%> <input type="text" id="ssnNo" class="form-control"
											value="<%=ssn%>" name="ssnNumber" maxlength="11"
											pattern="\d{3}-\d{2}-\d{4}"
											title="Please enter exactly 9 digits" size="40" height="10px"
											onkeyup="addHyphen(this)" required /> <%}else{
											%> <input type="text" id="ssnNo" class="form-control"
											name="ssnNumber" maxlength="11" pattern="\d{3}-\d{2}-\d{4}"
											title="Please enter exactly 9 digits" size="40" height="10px"
											onkeyup="addHyphen(this)" required /> <%} %>
									</font></font><br></td>
							</tr>



							<tr class="form-group">
								<td align="left" nowrap><b><font color="black"
										style="font-family: sans-serif;">Date of
											Birth:(DD-MM-YYYY) </font></b></td>
								<td class="col-sm-4"><font size="4"> <font
										color="blue"> <% if(randomId!=0 && randomizedResult=="randomized"){
											%> <input type="text" id="dateOfBirthId"
											placeholder="click to select date" class="form-control"
											class="hero-unit" name="dateOfBirth" value="<%=dateOfBirth%>"
											size="40" height="10px" required /> <%}else{
											 %> <input type="text" id="dateOfBirthId"
											placeholder="click to select date" class="form-control"
											class="hero-unit" name="dateOfBirth" size="40" height="10px"
											required /> <%} %>
									</font></font><br></td>
							</tr>
							<tr class="form-group">
								<td align="left" nowrap><b><font color="black"
										style="font-family: sans-serif;">Site: </font></b></td>
								<td class="col-sm-4" align="left"><select id="siteId"
									name="siteName" class="form-control" style="width: 400px;">
										<%
									List siteList = new ArrayList();
									siteList.add("523-Boston");
									if(randomId!=0 && randomizedResult=="randomized"){ %>
										<option value="<%=site%>" selected><%=site%></option>
										<% siteList.remove(site);
									for (int i = 0; i < siteList.size(); i++) {%>
										<option value="<%=siteList.get(i)%>"><%=siteList.get(i)%></option>
										<%
										}}else{
											for (int k = 0; k < siteList.size(); k++) { %>
										<option value="<%=siteList.get(k)%>"><%=siteList.get(k)%></option>
										<%	}}
									%>
								</select></td>
							</tr>
							<tr class="form-group">
								<td align="center" colspan=2
									style="padding-left: 20px; padding-top: 10px;" valign="top">
									<input type="submit" name="randomize" value="Randomize"
									style="width: 40%; font-size: 1.0em;"
									class="btn btn-large btn btn-success btn-lg btn-block" />
								</td>
							</tr>
							<tr class="form-group">
								<td align="left" nowrap><b><font color="black"
										style="font-family: sans-serif;">Result: </font></b></td>
								<td class="col-sm-4"><font size="4"> <font
										color="blue"> <% if(randomId!=0 && randomizedResult=="randomized"){
											%> <textarea id="randomizeNumber" class="form-control"
												rows="4" cols="50" disabled><%=treatmentValue%></textarea>
												 <font size=2px><%=randomNoGenTimestamp%></font> <%}else if(randomId==0 && randomizedResult=="randomized"){
										 %> <font color=red size=2px>No Randomizations
												available, please try again later.</font> <textarea
												id="randomizeNumber" class="form-control" rows="4" cols="50"
												disabled>
											</textarea> <%}else{ %> <textarea id="randomizeNumber"
												class="form-control" rows="4" cols="50" disabled></textarea>
											<%} %>
									</font></font><br></td>

							</tr>
							<%
						session.removeAttribute("UsrBean");
						session.removeAttribute("randomized");
							%>
						</table>

					</form>
				</div>
			</div>
		</div>
</body>
<%@include file="/WEB-INF/jsp/footer.jsp"%>
</html>