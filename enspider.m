%����novelfull��վ��С˵
clc


%���ô���
%com.mathworks.mlwidgets.html.HTMLPrefs.setProxyHost
%com.mathworks.mlwidgets.html.HTMLPrefs.setProxyPort

%ParseContent(str)
%return;

% if 0
%     novel_url = input('��������ַ������http://novelfull.com/index.php/lord-of-the-mysteries.html\n��ַ��', 's');
%     if isempty(novel_url)
%         novel_url = 'http://novelfull.com/index.php/lord-of-the-mysteries.html';
%     end
% end

% 
url_head = 'http://novelfull.com/'; %@todo ���Ϊ�Զ���ȡ 

%DownloadNovel('http://novelfull.com/index.php/lord-of-the-mysteries.html', url_head);
%DownloadNovel('http://novelfull.com/genius-doctor-black-belly-miss.html', url_head);
% DownloadNovel('http://novelfull.com/otherworldly-evil-monarch.html', url_head);
% DownloadNovel('http://novelfull.com/hidden-marriage.html', url_head);
% DownloadNovel('http://novelfull.com/ancient-godly-monarch.html', url_head);
DownloadNovel('http://novelfull.com/god-of-slaughter.html', url_head);
DownloadNovel('http://novelfull.com/dragon-marked-war-god.html', url_head);
DownloadNovel('http://novelfull.com/reincarnation-of-the-strongest-sword-god.html', url_head);
DownloadNovel('http://novelfull.com/peerless-martial-god.html', url_head);
DownloadNovel('http://novelfull.com/super-gene.html', url_head);
DownloadNovel('http://novelfull.com/king-of-gods.html', url_head);
DownloadNovel('http://novelfull.com/strongest-abandoned-son.html', url_head);
DownloadNovel('http://novelfull.com/my-house-of-horrors.html', url_head);
DownloadNovel('http://novelfull.com/trial-marriage-husband-need-to-work-hard.html', url_head);
DownloadNovel('http://novelfull.com/perfect-secret-love-the-bad-new-wife-is-a-little-sweet.html', url_head);
DownloadNovel('http://novelfull.com/martial-world.html', url_head);


function DownloadNovel(novel_url, url_head, begin_content_cnt)

    if (nargin<3)
      begin_content_cnt=1;
    end

    begin_page_cnt = floor(begin_content_cnt/50-0.001)+1;

    data = xwebread(novel_url);

    novel_info = ParseNovelPage(data);

    novel_info.title = regexprep(novel_info.title,  '[/\\\?*:"<>|]', '');
    novel_info.author = regexprep(novel_info.author,  '[/\\\?*:"<>|]', '');

    if begin_content_cnt>1
        fp = fopen([novel_info.title, ' - ',novel_info.author, '.html'], 'a', 'n', 'UTF-8');
    else
        fp = fopen([novel_info.title, ' - ',novel_info.author, '.html'], 'w', 'n', 'UTF-8');
        fprintf(fp, ['<h1>',novel_info.title,'</h1>\n']);
    end

    cnt = 0;
    cnt_page = 0;
    for  url = novel_info.index_urls
        url_str = url{1,1};
        cnt_page = cnt_page+1;
        fprintf(['Download Indexs 50p: ', url_head,url_str, '\n']);    
        if cnt_page<begin_page_cnt
            cnt = cnt+50;
            continue
        end
        %��ȡĿ¼ҳ����
        pause(0.02);
        str = xwebread([url_head,url_str]);    
 

        %������50�µ�����
        content_urls = ParseIndexPage(str);
        for c_url = content_urls
            cnt = cnt+1;

            c_url_str = c_url{1,1}{1,1};
            c_url_title = c_url{1,1}{1,2};
            fprintf(['Download ', url_head,c_url_str, '\n']);
            if cnt<begin_content_cnt
                continue
            end
            %��ȡ��������
            pause(0.02);
            str = xwebread([url_head,c_url_str]);
            
            %������������
            content = ParseContent(str);
            fprintf(fp, ['<h1>',c_url_title,'</h1>\n']);
            fprintf(fp, content);
            fprintf(fp, '\n');
        end
    end

    fclose('all');
end

function str = xwebread(url)
    options = weboptions;
    options.Timeout = 15;
    for i=1:15
        try
            str = webread(url, options); 
            break;
        catch
            warning(['ReadTimeOut:',url]);
            pause(i);
        end
    end
end

%FileWrite("tmp.txt", data);


%������ҳ
%��ȡ���С�����
%��ȡ��URL
%��ȡĿ¼��ҳ�����ҳ
%���ݻ�ȡĿ¼��ҳ�����ҳ������Ŀ¼ҳURL����
%������������Ŀ¼ҳ��ȡȫ������ҳURL����
%��ָ���½ڿ�ʼ������������ҳ
%��ȡ���ĸ�ʽ��������ļ�
%��ʱ��ʾ����


%������������
function str = ParseContent(str)
    str = regexp(str,  '<div id="chapter-content".*?class="chapter-end">', 'match', 'once'); 
    str = regexprep(str,  '<div class="cha-tit">.*?</div>', ''); 
    str = regexprep(str,  '<div class="ads.*?</div>', ''); 
    str = regexprep(str,  '<script.*?</script>', ''); 
    str = regexprep(str,  '<ins.*?</ins>', ''); 
    str = regexprep(str,  '<div  align="left">.*', ''); 
    str = regexprep(str,  '<hr.*?>', ''); 
    str = regexprep(str,  '<div.*?>', ''); 
    str = regexprep(str,  '</div.*?>', '');  
    str = regexprep(str,  '<!--.*?>', '');  
    str = regexprep(str,  '\s*<p>\s*</p>\s*', '');  
    str = regexprep(str,  '^\s*', '', 'lineanchors');    %	
		
    str = regexprep(str,  '^<p>\s*Chapter \d+[^<]*?</p>', '', 'lineanchors');    %
    str = regexprep(str,  '^<p>\s*<strong>\s*Chapter \d+.*?</p>', '', 'lineanchors');    %		
    str = regexprep(str,  '^<p>\s*<h3>\s*Chapter \d+.*?</p>', '', 'lineanchors');    %		
    str = regexprep(str,  '^<p>\s*<b>\s*Chapter \d+.*?</p>', '', 'lineanchors');    %		
		
    str = regexprep(str,  '^<p>\s*Translator:[^<]*?</p>', '', 'lineanchors');    %
    str = regexprep(str,  '^<p>\s*<strong>\s*Translator:.*?</p>', '', 'lineanchors');    %		
    str = regexprep(str,  '^<p>\s*<h3>\s*Translator:.*?</p>', '', 'lineanchors');    %		
    str = regexprep(str,  '^<p>\s*<b>\s*Translator:.*?</p>', '', 'lineanchors');    %		
			
    str = regexprep(str,  '^<p>\s*Editor:[^<]*?</p>', '', 'lineanchors');    %
    str = regexprep(str,  '^<p>\s*<strong>\s*Editor:.*?</p>', '', 'lineanchors');    %		
    str = regexprep(str,  '^<p>\s*<b>\s*Editor:.*?</p>', '', 'lineanchors');    %		
			
    str = regexprep(str,  '^<p>\s*Author:[^<]*?</p>', '', 'lineanchors');    %
    str = regexprep(str,  '^<p>\s*<strong>\s*Author:.*?</p>', '', 'lineanchors');    %		
    str = regexprep(str,  '^<p>\s*<b>\s*Author:.*?</p>', '', 'lineanchors');    %		
		
		
    str = regexprep(str,  '<p><p>', '<p>');  
    str = regexprep(str,  '<p></p>', '');  
end




%����Ŀ¼ҳ
function content_urls = ParseIndexPage(str)   
    tokens = regexpi(str,  '<h2>Chapter List</h2>(.*)<div class="dropdown-menu', 'tokens', 'once'); %use regexpi ignore case, default . include \n
    str = tokens{1,1};
    content_urls = regexpi(str,  '<a href="/(.*?)" title="(.*?)">', 'tokens');    
end


% ������ҳ
% novel_info.title ����
% novel_info.author ����
% novel_info.content_urls ��������
% novel_info.index_urls Ŀ¼ҳ����
function novel_info= ParseNovelPage(str)

    tokens = regexpi(str, '<h3 class="title">(.*?)</h3>', 'tokens', 'once');
    novel_info.title =  tokens{1,1};
    tokens = regexpi(str, '<h3>Author:</h3><a.*?>(.*?)</a>', 'tokens', 'once');
    novel_info.author =  tokens{1,1};
    
    %ǰ50������
    %tokens = regexpi(str,  '<h2>Chapter List</h2>(.*)<div class="dropdown-menu', 'tokens', 'once'); %use regexpi ignore case, default . include \n
    %str = tokens{1,1};
    %novel_info.content_urls = regexpi(str,  '<a href="/(.*?)" title="(.*?)">', 'tokens');
    
    tokens = regexpi(str,  '<ul class="pagination pagination-sm">(.*)</ul>', 'tokens', 'once'); %use regexpi ignore case, default . include \n
    content_index_str = tokens{1,1};
    tokens = regexpi(content_index_str,  '<li class="last">.*?<a href="/(.*?\?page=)(\d+).*".*?>', 'tokens');
    tokens = tokens{1,1};
    url_head = tokens{1,1};    
    last_page = [url_head, tokens{1,2}];
    
    novel_info.index_urls={};
    for i=1:999
        tmp = [url_head, num2str(i)];
        novel_info.index_urls{i} = tmp;
        if strcmp(last_page, tmp)
            break
        end           
    end
end


function FileWrite(filename, data, spec)
  if (nargin<3)
      spec='w+';
  end
  fp = fopen(filename, spec, 'native', 'UTF-8');
  fwrite(fp, data);
end
