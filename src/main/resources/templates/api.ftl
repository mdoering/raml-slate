[#ftl]
[#-- @ftlvariable name="" type="de.mdoering.raml.ApiView" --]
<!DOCTYPE html>
<html>
[#setting boolean_format="yes,no"]
[#global resId=0]
[#global opId=0]


[#macro fullpath method]
[#compress]
${model.baseUri()}[#if method.resource?? && method.resource()??]${method.resource().resourcePath()}[/#if]
[/#compress]
[/#macro]

[#macro para val]
    [#if val?? && val()??]<p>${val()}</p>[/#if]
[/#macro]

[#macro enumOrPattern typ]
[#compress]
    [#if typ.enumValues?? && typ.enumValues()?has_content]${typ.enumValues()?join(", ")}[/#if]
    [#if typ.pattern?? && typ.pattern()?has_content]${typ.pattern()}[/#if]
[/#compress]
[/#macro]

[#function baseType typ]
    [#return typ?remove_ending("[]")]
[/#function]

[#macro modelType typ]
    [#compress]
        [#assign bt = baseType(typ.type())]
        [#if hasType(bt)]<a href="#model-${bt}">${typ.type()}</a>[#elseif typ.enumValues?? && typ.enumValues()?has_content]enum[#else]${typ.type()!"string"}[/#if]
    [/#compress]
[/#macro]

[#macro example typ pre=true isArray=false]
    [#if typ.example?? && typ.example()?has_content]
        [#assign ex = typ.example()]
        [#if ex.structuredValue()??]
            [#if ex.structuredValue().isScalar()]
                [@jsonObj ex.structuredValue().value() isArray pre/]
            [#else]
                [#if pre]<pre class="example">[/#if]<code class="json">{
                [#list ex.structuredValue().properties() as p]
                    "${p.name()}":[#if p.isArray()][${p.values()?join(", ")}][#else]${p.value()}[/#if]
                [/#list]
    }</code>[#if pre]</pre>[/#if]
            [/#if]
        [#else]
            [@jsonObj ex.value() isArray pre/]
        [/#if]
    [/#if]
[/#macro]

[#macro jsonObj obj isArray pre]
    [#if pre]<pre class="example">[/#if]<code class="json">[#if isArray][[/#if]${obj}[#if isArray],${obj}][/#if]</code>[#if pre]</pre>[/#if]
[/#macro]

[#macro requestExample method]
    [#assign body = "" /]
    [#if method.body?? && method.body()?has_content]
        [#assign body = method.body()[0] /]
    [/#if]
    <pre class="example"><code class="http">
${method.method()?upper_case} ${baseUri.path}${method.resource().resourcePath()} HTTP/1.1
Host: ${baseUri.host}
[#list method.headers() as h]
${h.name()}: ${(h.example().value())!"..."}
[/#list]
[#if body?has_content]
Content-Type: ${body.name()}
[/#if]
</code>
[#if body?has_content]
[@jsonTypeExample body /]
[/#if]
</pre>

[#--
[#assign hasUriParams = isMethod && op.resource().uriParameters()?has_content /]
[#if op.queryParameters()?has_content || hasUriParams]
[#if hasUriParams]
[#list op.resource().uriParameters() as p]
<tr>
    <td>{${p.name()}}</td>
    <td>[@modelType p/]</td>
    <td>[@enumOrPattern p/]</td>
    <td>${p.required()!false}</td>
    <td>${p.defaultValue()!}</td>
    <td>${p.description()!}</td>
</tr>
[/#list]
[/#if]
[#list op.queryParameters() as p]
<tr>
    <td>${p.name()}</td>
    <td>[@modelType p/]</td>
    <td>[@enumOrPattern p/]</td>
    <td>${p.required()!false}</td>
    <td>${p.defaultValue()!}</td>
    <td>${p.description()!}</td>
</tr>
[/#list]
[/#if]
--]
[/#macro]

[#macro responseExample body resp=""]
    [#-- show content type --]
    [#if resp?has_content]
<pre class="example"><code class="http">
HTTP/1.1 ${headerCode(resp.code())}
Date: ${.now?string.full}
Content-Type: ${body.name()}
[#list resp.headers() as h]
${h.name()}: [#if ((h.example().value())!"")?starts_with("http")]${model.baseUri()}/...[#else]${(h.example().value())!"..."}[/#if]
[/#list]
</code>
    [/#if]
[@jsonTypeExample body/]
</pre>
[/#macro]

[#macro jsonTypeExample body]
    [#-- use this example or general one from type section --]
    [#if body.example()?has_content]
        [@example typ=body pre=false/]
    [#elseif body.type()??]
        [#assign bt = baseType(body.type())]
        [#assign typ = getType(bt)!]
        [#if typ??]
            [@example typ=typ pre=false isArray=body.type()?ends_with("[]")/]
        [/#if]
    [/#if]
[/#macro]

[#macro exampleHeaders headers]
<pre><code class="http">
[#compress]
[#list headers() as h]
    [#if h.example()??]
        [#assign ex = h.example()/]
        [#if ex.structuredValue()??]
${h.name()}: [@structuredJsonValue ex.structuredValue()/]
        [#else]
${h.name()}: ${ex.value()}
        [/#if]
    [#else]
${h.name()}: ...
    [/#if]
[/#list]
[/#compress]
</code></pre>
[/#macro]

[#macro structuredJsonValue val][@compress single_line=true]
    [#if val.isScalar()]
        ${val.value()}
    [#else]
        {
        [#list val.properties() as p]
            "${p.name()}": [#if p.isArray()][${p.values()?join(", ")}][#else]"${p.value()}"[/#if]
        [/#list]
        }
    [/#if]
[/@compress]
[/#macro]

[#macro headerTable headers]
    [#if headers()?has_content]
    <table><thead>
    <tr>
        <th>Name</th>
        <th>Type</th>
        <th>Required</th>
        <th>Description</th>
    </tr>
    </thead><tbody>
        [#list headers() as h]
        <tr>
            <td>${h.name()}</td>
            <td>${h.type()!"string"}[#if h.pattern?? && h.pattern()?has_content]: ${h.pattern()}[/#if]</td>
            <td>${h.required()!false}</td>
            <td>${h.description()!}</td>
        </tr>
        [/#list]
    </tbody></table>
    [/#if]
[/#macro]

[#macro method op]
    [#global opId += 1]
    [#assign isMethod=op.method??]

    [#if isMethod]
        [@requestExample op/]
        <h3><code class="prettyprint">${op.method()?upper_case}</code> [@fullpath op/]</h3>
        [@para op.description /]
    [/#if]

    [#if op.headers()?has_content]
    <h3 id="op${opId}-request-header">Header</h3>
        [@headerTable op.headers/]
    [/#if]

    [#if isMethod && op.body()?has_content]
    <h3 id="op${opId}-request-body">Body</h3>
        [#list op.body() as body]
            <p><code>${body.name()}</code></p>
            <p>Content: [@modelType body/]</p>
        [/#list]
    [/#if]

    [#assign hasUriParams = isMethod && op.resource().uriParameters()?has_content /]
    [#if op.queryParameters()?has_content || hasUriParams]
        <h3 id="op${opId}-request-params">Parameters</h3>
        <table><thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Pattern</th>
            <th>Required</th>
            <th>Default</th>
            <th>Description</th>
        </tr>
        </thead><tbody>
            [#if hasUriParams]
                [#list op.resource().uriParameters() as p]
                <tr>
                    <td>{${p.name()}}</td>
                    <td>[@modelType p/]</td>
                    <td>[@enumOrPattern p/]</td>
                    <td>${p.required()!false}</td>
                    <td>${p.defaultValue()!}</td>
                    <td>${p.description()!}</td>
                </tr>
                [/#list]
            [/#if]
            [#list op.queryParameters() as p]
            <tr>
                <td>${p.name()}</td>
                <td>[@modelType p/]</td>
                <td>[@enumOrPattern p/]</td>
                <td>${p.required()!false}</td>
                <td>${p.defaultValue()!}</td>
                <td>${p.description()!}</td>
            </tr>
            [/#list]
        </tbody></table>
    [/#if]

    [#if op.queryString()??]
    <h3 id="op${opId}-querystring">Query String</h3>
    [#-- TODO: show all --]
    <p>{op.queryString().name()} {op.queryString().type()}</p>
        [@para op.queryString().description /]
    [/#if]

    [#if op.responses()??]
        [#list op.responses() as r]
            <h3 id="op${opId}-responses" class="clear">Response ${r.code()}</h3>
            [@para r.description /]
            [#if r.headers()?has_content]
                <h3 id="op${opId}-response-header-${r.code()}">Header</h3>
                [@headerTable r.headers/]
            [/#if]
            [#if r.body()?has_content]
                [#list r.body() as body]
                    [@responseExample body r /]
                    <p><code>${body.name()}</code></p>
                    <p>Content: [@modelType body/]</p>
                [/#list]
            [/#if]
        [/#list]
    [/#if]
[/#macro]

[#macro resource res]
    [#global resId += 1]

    [#if res.parentResource()??]
        <h2 id="resource-${resId}">${res.resourcePath()}</h2>
    [#else]
        <h1 id="resource-${resId}">${res.resourcePath()}</h1>
    [/#if]

    [@para res.description /]

    [#list res.methods() as action]
        [@method action/]
    [/#list]

    [#list res.resources() as child]
        [@resource child/]
    [/#list]
[/#macro]


<head>
    <meta charset="utf-8">
    <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>${model.title()} (${model.version()}</title>
    <link href="screen.css" rel="stylesheet" media="screen" />
    <link href="print.css" rel="stylesheet" media="print" />
    [#-- json highlighting --]
    <link href="highlight.css" rel="stylesheet" >
    <script src="highlight.pack.js"></script>
    <style>
        .clear { clear: both}
        .highlight table td { padding: 5px; }
        .highlight table pre { margin: 0; }
        .highlight, .highlight .w {
            color: #f8f8f2;
            background-color: #272822;
        }
        .highlight .err {
            color: #151515;
            background-color: #ac4142;
        }
        .highlight .c, .highlight .cd, .highlight .cm, .highlight .c1, .highlight .cs {
            color: #505050;
        }
        .highlight .cp {
            color: #f4bf75;
        }
        .highlight .nt {
            color: #f4bf75;
        }
        .highlight .o, .highlight .ow {
            color: #d0d0d0;
        }
        .highlight .p, .highlight .pi {
            color: #d0d0d0;
        }
        .highlight .gi {
            color: #90a959;
        }
        .highlight .gd {
            color: #ac4142;
        }
        .highlight .gh {
            color: #6a9fb5;
            background-color: #151515;
            font-weight: bold;
        }
        .highlight .k, .highlight .kn, .highlight .kp, .highlight .kr, .highlight .kv {
            color: #aa759f;
        }
        .highlight .kc {
            color: #d28445;
        }
        .highlight .kt {
            color: #d28445;
        }
        .highlight .kd {
            color: #d28445;
        }
        .highlight .s, .highlight .sb, .highlight .sc, .highlight .sd, .highlight .s2, .highlight .sh, .highlight .sx, .highlight .s1 {
            color: #90a959;
        }
        .highlight .sr {
            color: #75b5aa;
        }
        .highlight .si {
            color: #8f5536;
        }
        .highlight .se {
            color: #8f5536;
        }
        .highlight .nn {
            color: #f4bf75;
        }
        .highlight .nc {
            color: #f4bf75;
        }
        .highlight .no {
            color: #f4bf75;
        }
        .highlight .na {
            color: #6a9fb5;
        }
        .highlight .m, .highlight .mf, .highlight .mh, .highlight .mi, .highlight .il, .highlight .mo, .highlight .mb, .highlight .mx {
            color: #90a959;
        }
        .highlight .ss {
            color: #90a959;
        }
    </style>
    <script src="slate.js"></script>
    <script>
        $(document).ready(function() {
            $('pre.example code').each(function(i, block) {
                hljs.highlightBlock(block);
            });
        });
    </script>
</head>

<body class="index" data-languages="[]">
<a href="#" id="nav-button">
      <span>
        NAV
        <img src="navbar.png" />
      </span>
</a>
<div class="tocify-wrapper">
    [#if cfg.logoFileName?has_content]
        <img src="${cfg.logoFileName}" />
    [#else]
        <h3>API Docs</h3>
    [/#if]
    <div class="lang-selector">
    </div>
    <div class="search">
        <input type="text" class="search" id="input-search" placeholder="Search">
    </div>
    <ul class="search-results"></ul>
    <div id="toc" class="tocify">
    </div>
    <ul class="toc-footer">
    </ul>
</div>
<div class="page-wrapper">
    <div class="dark-box"></div>

    <div class="content">

        <h1 id="introduction">${model.title()} (${model.version()})</h1>
        <h3><code>${model.baseUri()}</code></h3>

        [@para model.description /]

        [#list model.documentation() as item]
            <h2 id="documentation-${item_index}">${(item.title())}</h2>
            <p>${item.content()}</p>
        [/#list]

        [#assign vocabs = [] /]

        [#if model.types()?has_content]
            <h1 id="model">Data Model</h1>
            [#list model.types() as typ]
                [#if !cfg.isTypeExcluded(typ.name())]
                    [#if typ.enumValues?? && typ.enumValues()?has_content]
                        [#assign vocabs = vocabs + [ {"name":typ.name(), "type":typ} ] /]
                    [#else]
                        <h2 id="model-${typ.name()}">${typ.displayName()}</h2>

                        [@example typ /]

                        [@para typ.description /]

                        [#if typ.properties?? && typ.properties()?has_content]
                            <table><thead>
                            <tr>
                                <th>Name</th>
                                <th>Type</th>
                                <th>Pattern</th>
                                <th>Required</th>
                                <th>Description</th>
                            </tr>
                            </thead><tbody>
                                [#list typ.properties() as p]
                                <tr>
                                    <td>${p.name()!}</td>
                                    <td>[@modelType p/]</td>
                                    <td>[@enumOrPattern p/]</td>
                                    <td>${p.required()!}</td>
                                    <td>${p.description()!}</td>
                                </tr>
                                [/#list]
                            </tbody></table>
                        [/#if]
                    [/#if]
                [/#if]
            [/#list]
        [/#if]

    [#if vocabs?has_content]
        <h1 id="vocabs">Vocabularies</h1>
        [#list vocabs?sort_by("name") as t]
            [#assign typ = t.type /]

            <h2 id="model-${t.type.name()}">${typ.displayName()}</h2>

            [@example typ /]

            <p><strong>Enumeration</strong>: [#list typ.enumValues() as e]<em>${e}</em>[#if e_has_next], [/#if][/#list]</p>

            [@para typ.description /]

            [#if typ.properties?? && typ.properties()?has_content]
                <table><thead>
                <tr>
                    <th>Name</th>
                    <th>Type</th>
                    <th>Pattern</th>
                    <th>Required</th>
                    <th>Description</th>
                </tr>
                </thead><tbody>
                    [#list typ.properties() as p]
                    <tr>
                        <td>${p.name()!}</td>
                        <td>[@modelType p/]</td>
                        <td>[@enumOrPattern p/]</td>
                        <td>${p.required()!}</td>
                        <td>${p.description()!}</td>
                    </tr>
                    [/#list]
                </tbody></table>
            [/#if]
        [/#list]
    [/#if]

        <h1 id="authentication">Authentication</h1>
            [#if model.securedBy()?has_content]
                <p>The entire API is protected and authentication can be done through:</p>
                <ul>
                    [#list model.securedBy() as sec]
                        <li><a href="#auth-${sec.name()}">${sec.name()}</a></li>
                    [/#list]
                </ul>
            [/#if]

            [#list model.securitySchemes() as sec]
                <h2 id="auth-${sec.name()}">${sec.type()!sec.displayName()}</h2>
                [@para sec.description /]

                [#if sec.describedBy()?has_content]
                    [@method sec.describedBy()/]
                [/#if]

                [#if sec.settings()?has_content]
                    TODO: SETTINGS
                [/#if]

            [/#list]

        [#list model.resources() as res]
            [@resource res/]
        [/#list]

        <aside class="success">
            Remember — a happy kitten is an authenticated kitten!
        </aside>


    </div>

    <div class="dark-box">
        <div class="lang-selector">
            <h2>&nbsp;&nbsp;&nbsp;&nbsp;Examples</h2>

        </div>
    </div>
</div>
</body>
</html>
