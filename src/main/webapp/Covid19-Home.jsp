<%@page import="com.va.UserBean"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.va.DbManager"%>

<jsp:useBean id="UsrBean" scope="request" class="com.va.UserBean" />
<jsp:useBean id="randomized" scope="request" class="java.lang.String" />
<jsp:useBean id="duplicatemessage" scope="request" class="java.lang.String" />

<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv='cache-control' content='no-cache'>
<meta http-equiv='expires' content='0'>
<meta http-equiv='pragma' content='no-cache'>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="stylesheet" href="css/bootstrap-datepicker.css">
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/bootstrap-datepicker.js"></script>
<link href="css/styles.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

$(document).ready(function() {
	$('#dateOfBirthId').datepicker({
		 format: "mm-dd-yyyy",
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
       
function resetForm() {
	document.getElementById("homeformId").reset();
	 document.getElementById("firstNameId").value = "";
	 document.getElementById("lastNameId").value = "";
	 document.getElementById("ssnNo").value = "";
	 document.getElementById("dateOfBirthId").value = "";
	 $('#siteId').prop("required", true);
	 $('#siteId').append('<option value="" selected>--Select an option--</option>');
	 var optionValues =[];
	 $('#siteId option').each(function(){
	    if($.inArray(this.value, optionValues) >-1){
	       $(this).remove();
	    }else{
	       optionValues.push(this.value);
	    }
	 });
	 document.getElementById("randomizeNumber").value = "";
	 $('#duplicateMessage').html("");
	 $('#message').html("");
	 $('#noRandomizationmessage').html("");
}

</script>


<title>Covid19-Trial Randomization</title>

</head>
<body>
	<%
String duplicateSSNMessage = (String)request.getAttribute("duplicatemessage");
UserBean userBean = (UserBean) request.getAttribute("UsrBean");
String firstName = userBean.getFirstName();
String lastName = userBean.getLastName();
String ssn = userBean.getSsn();
String dateOfBirth = userBean.getDateOfBirth();
String site = userBean.getSite();
int randomId = userBean.getRandomNumber();
String treatmentValue = userBean.getTreatmentValue();
Timestamp randomNoGenTimestamp = userBean.getRandomizedDateTime();
int availableRandomizationsCount  = DbManager.getAvailableRandomizationsCount();
String randomizedResult = (String)request.getAttribute("randomized");
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

					<form name="homeForm" id="homeformId" method="post"
						action="Covid19Randomization" class="form-horizontal">
						<%if(duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
						<div id="duplicateMessage"><font color=red size=2px><%=duplicateSSNMessage%></font></div>
							<%}%>
						<table
							style="height: 550px; align: center; border-collapse: collapse;"
							cellpadding="0" cellspacing="0">

							<tr class="form-group">
								<td align="left"><b><font
										color="black" style="font-family: sans-serif;">First Name:
									</font></b></td>
								<td align="left">
									<font size="4"><font color="blue"> 
									<% if(randomId==0 && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
									 <input type="text" class="form-control" name="firstName" id="firstNameId" value="<%=firstName%>"/>
									  <%}else if(randomId!=0 && randomizedResult=="randomized" && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
									 <input type="text" class="form-control" name="firstName" id="firstNameId" value="<%=firstName%>"/>
									  <%}else if((randomId!=0 && randomizedResult=="randomized") && (duplicateSSNMessage==null || duplicateSSNMessage.isEmpty())){%>
									   <input type="text" class="form-control" name="firstName" id="firstNameId" value="<%=firstName%>"/>
									  <%}else if(randomId==0 && randomizedResult=="randomized"){%>
									  <input type="text" class="form-control" name="firstName" id="firstNameId" value="<%=firstName%>"/>
									    <%}else{%>
									     <input type="text" class="form-control" name="firstName" id="firstNameId"/> <%} %>
									</font></font><br>
								</td>
							</tr>
							<tr class="form-group">
								<td align="left"><b><font color="black"
										style="font-family: sans-serif;">Last Name: </font></b></td>
								<td align="left"><font size="4"> <font
										color="blue"> 
										<% if(randomId==0 && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
										 <input type="text" class="form-control" name="lastName" id="lastNameId" value="<%=lastName%>" required="required" />
										   <%}else if(randomId!=0 && randomizedResult=="randomized" && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
										   <input type="text" class="form-control" name="lastName" id="lastNameId" value="<%=lastName%>" required="required" />
										  <%}else if((randomId!=0 && randomizedResult=="randomized") && (duplicateSSNMessage==null || duplicateSSNMessage.isEmpty())){%>
										   <input type="text" class="form-control" name="lastName" id="lastNameId" value="<%=lastName%>" required="required" />
										   <%}else if(randomId==0 && randomizedResult=="randomized"){%>
										    <input type="text" class="form-control" name="lastName" id="lastNameId" value="<%=lastName%>" required="required" />
										  <%}else{%>
										   <input type="text" class="form-control" name="lastName" id="lastNameId"
											required="required" /> <%} %>
									</font></font><br></td>
							</tr>
							<tr class="form-group">
								<td align="left"><b><font color="black"
										style="font-family: sans-serif;">SSN: </font></b></td>
								<td align="left"><font size="4"> <font
										color="blue">
										 <% if(randomId==0 && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
										  <input type="text" id="ssnNo" class="form-control" value="<%=ssn%>" name="ssnNumber" maxlength="11" pattern="\d{3}-\d{2}-\d{4}" title="Please enter exactly 9 digits" onkeyup="addHyphen(this)" required />
										   <%}else if(randomId!=0 && randomizedResult=="randomized" && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
										   <input type="text" id="ssnNo" class="form-control" value="<%=ssn%>" name="ssnNumber" maxlength="11" pattern="\d{3}-\d{2}-\d{4}" title="Please enter exactly 9 digits" onkeyup="addHyphen(this)" required />
										   <%}else if((randomId!=0 && randomizedResult=="randomized") && (duplicateSSNMessage==null || duplicateSSNMessage.isEmpty())){%>
										   <input type="text" id="ssnNo" class="form-control" value="<%=ssn%>" name="ssnNumber" maxlength="11" pattern="\d{3}-\d{2}-\d{4}" title="Please enter exactly 9 digits" onkeyup="addHyphen(this)" required />
										   <%}else if(randomId==0 && randomizedResult=="randomized"){%>
										   <input type="text" id="ssnNo" class="form-control" value="<%=ssn%>" name="ssnNumber" maxlength="11" pattern="\d{3}-\d{2}-\d{4}" title="Please enter exactly 9 digits" onkeyup="addHyphen(this)" required />
										   <%}else{%>
										    <input type="text" id="ssnNo" class="form-control" name="ssnNumber" maxlength="11" pattern="\d{3}-\d{2}-\d{4}" title="Please enter exactly 9 digits" onkeyup="addHyphen(this)" required />
										     <%}%>
									</font></font><br></td>
							</tr>
							<tr class="form-group">
								<td align="left"><b><font color="black"
										style="font-family: sans-serif;">Date of
											Birth:(MM-DD-YYYY) </font></b></td>
								<td align="left"><font size="4"> <font
										color="blue">
										 <% if(randomId==0 && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
										  <input type="text" id="dateOfBirthId"	placeholder="click to select date" class="form-control"	class="hero-unit" name="dateOfBirth" value="<%=dateOfBirth%>" required />
										  <%}else if(randomId!=0 && randomizedResult=="randomized" && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
										  <input type="text" id="dateOfBirthId"	placeholder="click to select date" class="form-control"	class="hero-unit" name="dateOfBirth" value="<%=dateOfBirth%>" required />
										  <%}else if((randomId!=0 && randomizedResult=="randomized") && (duplicateSSNMessage==null || duplicateSSNMessage.isEmpty())){%>
										  <input type="text" id="dateOfBirthId"	placeholder="click to select date" class="form-control"	class="hero-unit" name="dateOfBirth" value="<%=dateOfBirth%>" required />
										  <%}else if(randomId==0 && randomizedResult=="randomized"){%>
										  <input type="text" id="dateOfBirthId"	placeholder="click to select date" class="form-control"	class="hero-unit" name="dateOfBirth" value="<%=dateOfBirth%>" required />
										   <%}else{%>
										    <input type="text" id="dateOfBirthId" placeholder="click to select date" class="form-control" class="hero-unit" name="dateOfBirth" required />
										     <%}%>
									</font></font><br></td>
							</tr>
							<tr class="form-group">
								<td align="left"><b><font color="black"
										style="font-family: sans-serif;">Site: </font></b></td>
								<td align="left"><select id="siteId"
									name="siteName" class="form-control" style="width: 400px;" required>
										<%
									List siteList = new ArrayList();
									siteList.add("523-Boston");
									siteList.add("650-Providence");
									siteList.add("402-Togus");
									siteList.add("689-West Haven");
									siteList.add("405-White River");
									if(randomId==0 && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){ %>
									<option value="" selected>--Select an option--</option>
									<option value="<%=site%>" selected><%=site%></option>
										<% siteList.remove(site);
									for (int i = 0; i < siteList.size(); i++) {%>
										<option value="<%=siteList.get(i)%>"><%=siteList.get(i)%></option>
										<%}}else if(randomId!=0 && randomizedResult=="randomized" && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){ %>
										<option value="" selected>--Select an option--</option>
									<option value="<%=site%>" selected><%=site%></option>
										<% siteList.remove(site);
									for (int i = 0; i < siteList.size(); i++) {%>
										<option value="<%=siteList.get(i)%>"><%=siteList.get(i)%></option>
										<%}}else if((randomId!=0 && randomizedResult=="randomized") && (duplicateSSNMessage==null || duplicateSSNMessage.isEmpty())){ %>
										<option value="" selected>--Select an option--</option>
									<option value="<%=site%>" selected><%=site%></option>
										<% siteList.remove(site);
									for (int i = 0; i < siteList.size(); i++) {%>
										<option value="<%=siteList.get(i)%>"><%=siteList.get(i)%></option>
										<%}}else if(randomId==0 && randomizedResult=="randomized"){ %>
										<option value="" selected>--Select an option--</option>
										<option value="<%=site%>" selected><%=site%></option>
										<% siteList.remove(site);
									for (int i = 0; i < siteList.size(); i++) {%>
										<option value="<%=siteList.get(i)%>"><%=siteList.get(i)%></option>
										<%}}else{%>
										<option value="" selected>--Select an option--</option>
											<%for (int k = 0; k < siteList.size(); k++) { %>
										<option value="<%=siteList.get(k)%>"><%=siteList.get(k)%></option>
										<%	}}
									%>
								</select></td>
							</tr>
							<tr class="form-group">
							<td></td>
							<td align="left">
									<input type="submit" name="randomize" value="Randomize"
									class="btn btn-success"/>
									<input type="button" name="clear" value="Next Patient" onclick="resetForm();"
									class="btn btn-success" />
								</td>
							</tr>
							<tr class="form-group">
								<td align="left"><b><font
										color="black" style="font-family: sans-serif;">Available Randomizations:
									</font></b></td>
								<td align="left">
									<font size="4"><font color="blue"> 
									<% if(randomId==0 && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
									 <input type="text" class="form-control" name="availableRandomization" id="availableRandomizationId" value=<%=availableRandomizationsCount%> disabled/>
									  <%}else if(randomId!=0 && randomizedResult=="randomized" && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
									 <input type="text" class="form-control" name="availableRandomization" id="availableRandomizationId" value=<%=availableRandomizationsCount%> disabled/>
									  <%}else if((randomId!=0 && randomizedResult=="randomized") && (duplicateSSNMessage==null || duplicateSSNMessage.isEmpty())){%>
									   <input type="text" class="form-control" name="availableRandomization" id="availableRandomizationId" value=<%=availableRandomizationsCount%> disabled/>
									  <%}else if(randomId==0 && randomizedResult=="randomized"){%>
									  <input type="text" class="form-control" name="availableRandomization" id="availableRandomizationId" value=<%=availableRandomizationsCount%> disabled/>
									    <%}else{%>
									     <input type="text" class="form-control" name="availableRandomization" id="availableRandomizationId" value=<%=availableRandomizationsCount%> disabled/> <%} %>
									</font></font><br>
								</td>
							</tr>
							<tr class="form-group">
								<td align="left"><b><font color="black"
										style="font-family: sans-serif;">Result: </font></b></td>
								<td align="left"><font size="4"> <font
										color="blue">
										 <%if(randomId==0 && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
										  <textarea id="randomizeNumber" class="form-control"
												rows="4" cols="50" disabled></textarea>
												 <div id="message"><font size=2px></font></div>
												  <%}else if(randomId!=0 && randomizedResult=="randomized" && duplicateSSNMessage!=null && !duplicateSSNMessage.isEmpty()){%>
												  <textarea id="randomizeNumber" class="form-control"
													rows="4" cols="50" disabled><%=treatmentValue%></textarea>
													 <div id="message"><font size=2px><%=randomNoGenTimestamp%></font></div>
													  <%}else if((randomId!=0 && randomizedResult=="randomized") && (duplicateSSNMessage==null || duplicateSSNMessage.isEmpty())){%>
													  <textarea id="randomizeNumber" class="form-control"
														rows="4" cols="50" disabled><%=treatmentValue%></textarea>
														 <div id="message"><font size=2px><%=randomNoGenTimestamp%></font></div>
														  <%}else if(randomId==0 && randomizedResult=="randomized"){%>
										 <textarea id="randomizeNumber" class="form-control" rows="4" cols="50"	disabled></textarea>
										 <div id="noRandomizationmessage"><font color=red size=2px>No Randomizations
												available, please try again later.</font></div>
												  <%}else{%>
												  <textarea id="randomizeNumber" class="form-control" rows="4" cols="50" disabled></textarea>
											<%}%>
									</font></font><br></td>

							</tr>
							<%
							request.removeAttribute("UsrBean");
							request.removeAttribute("randomized");
							request.removeAttribute("duplicatemessage");
							%>
						</table>

					</form>
				</div>
			</div>
		</div>
</body>
<%@include file="/WEB-INF/jsp/footer.jsp"%>
</html>