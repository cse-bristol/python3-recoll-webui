%import shlex, unicodedata, os
<div class="search-result">
    %number = (query['page'] - 1)*config['perpage'] + i + 1
    <div class="search-result-number"><a href="#r{{d['sha']}}">#{{number}}</a></div>
    %url = d['url'].decode('utf-8').replace('file://', '')
    %for dr, prefix in config['mounts'].items():
        %url = url.replace(dr, prefix)
    %end
    <div class="search-result-title" id="r{{d['sha']}}" title="{{d['abstract']}}">
    %if 'title_link' in config and config['title_link'] != 'download':
        %if config['title_link'] == 'open':
            <a onclick="hrefToClipboard(this)" href="{{url}}">{{d['label'] or d['filename']}}</a>
        %elif config['title_link'] == 'preview':
            <a href="preview/{{number-1}}?{{query_string}}">{{d['label']}}</a>
        %end
    %else:
        <a href="download/{{number-1}}?{{query_string}}">{{d['label'] or d['filename']}}</a>
    %end
    </div>
    %if len(d['ipath']) > 0:
        <div class="search-result-ipath">[{{d['ipath']}}]</div>
    %end
    %if 'author' in d and len(d['author']) > 0:
        <div class="search-result-author">{{d['author']}}</div>
    %end
    <div class="search-result-url">
        %urllabel = os.path.dirname(d['url'].decode('utf-8').replace('file://', ''))
        %for r in config['dirs']:
            %urllabel = urllabel.replace(r.rsplit('/',1)[0] + '/' , '')
        %end
        <a onclick="hrefToClipboard(this)" href="{{os.path.dirname(url)}}">{{urllabel}}/{{d['filename']}}</a>
    </div>
    <div class="search-result-links">
        <a onclick="hrefToClipboard(this)" href="{{url}}">Open</a>
        <a href="download/{{number-1}}?{{query_string}}">Download</a>
    %if hasrclextract:
        <a href="preview/{{number-1}}?{{query_string}}" target="_blank">Preview</a>
    %end
    </div>
    <div class="search-result-date">{{d['time']}}</div>
    <div class="search-result-snippet">
    %if len(d['snippet']) > 0:
      %snippet = d['snippet'].decode('utf-8')
      %snippet_0 = snippet.split('.')[0] + '.'
      %snippet_n = snippet[len(snippet_0):]

      <details>
        <summary>{{!snippet_0}}</summary>
        <p>{{!snippet_n}}</p>
      </details>
    %end     
    </div>
</div>
<!-- vim: fdm=marker:tw=80:ts=4:sw=4:sts=4:et:ai
-->
