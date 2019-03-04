# Documentation of OTRS JavaScript Namespaces

This is the documentation of all JavaScript namespaces used in OTRS. The information
is automatically extracted from the JavaScript source files of
[the rel-6_0 branch](https://github.com/OTRS/otrs/tree/rel-6_0).

If you find any error or an inconsistency, please feel free to fix the issue and send us a pull request!

## Structure of JavaScript Namespaces

Every namespace has a matching JavaScript file. Some namespaces are used in every OTRS screen or dialog (e.g.
[Core.Form](Core.Form.html), [Core.AJAX](Core.AJAX.html)), some are only loaded and used for a specific screen (e.g.
[Core.Agent.Admin.ACL](Core.Agent.Admin.ACL.html),
[Core.Agent.Admin.ProcessManagement](Core.Agent.Admin.ProcessManagement.html)).

For the agent interface [Core.Agent](Core.Agent.html) is a good starting point, the main functions for the customer
interface can be found in the [Core.Customer](Core.Customer.html) namespace. For frontend-agnostic JavaScript have a
look at the [Core.UI.*](Core.UI.html) namespaces.
