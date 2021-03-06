function initPage()
{
	//head text
//	var head_tag = document.getElementsByTagName("h1");
//	var head_text = document.createTextNode(bh_fix_ip_setting);
//	head_tag[0].appendChild(head_text);
//
//	var paragraph = document.getElementsByTagName("p");
//	//var paragraph_text = document.createTextNode(bh_enter_ip_setting);
//	//paragraph[0].appendChild(paragraph_text);
//
//
//	//main content items
//	var IP_addr_div = document.getElementById("IP_addr");
//	var IP_addr_text = document.createTextNode(bh_info_mark_ip);
//	IP_addr_div.appendChild(IP_addr_text);
//
//	var Sub_mask_div = document.getElementById("Sub_mask");
//	var Sub_mask_text = document.createTextNode(bh_info_mark_mask);
//	Sub_mask_div.appendChild(Sub_mask_text);
//
//	var Gateway_div = document.getElementById("Gateway")
//	var Gateway_text = document.createTextNode(bh_constatus_defgtw);
//	Gateway_div.appendChild(Gateway_text);
//
//	var preDNS_div = document.getElementById("preDNS")
//	var preDNS_text = document.createTextNode(bh_preferred_dns);
//	preDNS_div.appendChild(preDNS_text);
//
//	var alteDNS_div = document.getElementById("alteDNS")
//	var alteDNS_text = document.createTextNode(bh_alternate_dns);
//	alteDNS_div.appendChild(alteDNS_text);


	//set input event action
/*	var IP_addr_input = document.getElementById("inputIPaddr");
	IP_addr_input.onkeypress = ipaddrKeyCode;

	var sub_mask_input = document.getElementById("inputSubMask");
	sub_mask_input.onkeypress = ipaddrKeyCode;
*/

	//buttons
	var btns_container_div1 = document.getElementById("btnsContainer_div1");
	btns_container_div1.onclick = function()
	{
		location.href = "BRS_RUS_manual_ip_type_check.html";	
	}
	var btns_container_div2 = document.getElementById("btnsContainer_div2");
	btns_container_div2.onclick = function()
	{
		return checkStaticIP();
	}
//	var btn = document.getElementById("btn_text_div");
//	var btn_text = document.createTextNode(bh_next_mark);
//	btn.appendChild(btn_text);

	//show firmware version
        showFirmVersion("none");
}

function checkStaticIP()
{

	var ip_choices_div = document.getElementById("staticIP_choices_div");
	var ip_choices = ip_choices_div.getElementsByTagName("input");
	var forms = document.getElementsByTagName("form");
	var cf = forms[0];
/*
	if(ip_choices[1].checked)
    {
		if(check_static_ip_mask()==false)
			return false;
		if(check_ether_samesubnet()==false)
			return false;
	}
*/
	cf.submit();
//	location.href="BRS_04_applySettings.html";

	return true;
}

function check_static_ip_mask()
{
	var ether_ipaddr = document.getElementById("inputIPaddr");
	var ether_subnet = document.getElementById("inputSubMask");

	if(checkipaddr(ether_ipaddr.value)==false || is_sub_or_broad(ether_ipaddr.value, ether_ipaddr.value, ether_subnet.value) == false)
	{
		alert(getErrorMsgByVar("bh_invalid_ip"));
		return false;
	}
	if(checksubnet(ether_subnet.value)==false)
	{
		alert(getErrorMsgByVar("bh_invalid_mask"));
		return false;
	}


	return true;
}

function check_ether_samesubnet()
{
	var ether_ipaddr = document.getElementById("inputIPaddr");
	var ether_subnet = document.getElementById("inputSubMask");

	if(isSameSubNet(ether_ipaddr.value,ether_subnet.value,lan_ip,lan_subnet) == true)
	{
		alert(getErrorMsgByVar("bh_same_lan_wan_subnet"));
		return false;
	}
	if(isSameSubNet(ether_ipaddr.value,lan_subnet,lan_ip,lan_subnet) == true)
	{
		alert(getErrorMsgByVar("bh_same_lan_wan_subnet"));
		return false;
	}
	if(isSameSubNet(ether_ipaddr.value,ether_subnet.value,lan_ip,ether_subnet.value) == true)
	{
		alert(getErrorMsgByVar("bh_same_lan_wan_subnet"));
		return false;
	}
	if(isSameIp(ether_ipaddr.value,lan_ip) == true)
	{
		alert(getErrorMsgByVar("bh_same_lan_wan_subnet"));
		return false;
	}

	return true;
}

function check_static_dns(wan_assign)
{
	var ether_ipaddr = document.getElementById("inputIPaddr");
	var ether_dnsaddr1 = document.getElementById("inputPreDns");
	var ether_dnsaddr2 = document.getElementById("inputSecDns");

	if( check_DNS(ether_dnsaddr1.value,ether_dnsaddr2.value,wan_assign,ether_ipaddr.value))
		return true;
	else
		return false;
}

addLoadEvent(initPage);



