/*
 Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.md or http://ckeditor.com/license
*/
CKEDITOR.plugins.add("autolink",{requires:"clipboard",init:function(c){c.on("paste",function(a){var b=a.data.dataValue;a.data.dataTransfer.getTransferType(c)!=CKEDITOR.DATA_TRANSFER_INTERNAL&&!(-1<b.indexOf("<"))&&(b=b.replace(/^(https?|ftp):\/\/(-\.)?([^\s\/?\.#-]+\.?)+(\/[^\s]*)?[^\s\.,]$/ig,'<a href="$&">$&</a>'),b!=a.data.dataValue&&(a.data.type="html"),a.data.dataValue=b)})}});