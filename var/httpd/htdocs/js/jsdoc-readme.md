# Documentation of OTRS JavaScript Namespaces

This is the documentation of all JavaScript namespaces used in OTRS Helpdesk. The information
is automatically extracted from the JavaScript source files of [the master branch](https://github.com/OTRS/otrs/tree/master).

If you find any error or inconsistency, please feel free to fix the issue and send us a pull request!

## Structure of JavaScript Namespaces

Every namespace has a matching JavaScript file. Some namespaces are used in every OTRS screen or dialog
(e.g. Core.Form, Core.AJAX), some others are only loaded and used for a specific screen
(e.g. Core.Agent.Admin.SysConfig, Core.Agent.Admin.ProcessManagement).

For the Agent Interface Core.Agent it a good starting point, the main functions for the Customer Interface can be found in 
the Core.Customer Namespace. For frontend-specific JavaScript have a look at the Core.UI.* Namespaces.