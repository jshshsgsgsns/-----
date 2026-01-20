<template>
    <div class="chat-container">
        <div v-for="(item, i) in contentList" :key="i" 
            :class="{ 'message-wrapper': true, 'user-message': item.role == 'user', 'ai-message': item.role !== 'user' }">
            
            <div class="message-content">
                <div class="avatar" v-if="item.role !== 'user'">
                    AI
                </div>
                <div class="avatar user-avatar" v-if="item.role == 'user'">
                    U
                </div>
                
                <div class="message-body">
                    <div v-if="item.content && item.content !== 'wait'"
                        :class="{ 'message-bubble': true, 'user-bubble': item.role == 'user', 'ai-bubble': item.role !== 'user' }" 
                        v-html="mdIt(item.content)">
                    </div>
                    <div v-if="item.content == 'wait'" class="message-bubble ai-bubble">
                        <span class="typing-indicator"><i class="el-icon-more"></i></span>
                    </div>
                    
                    <div class="message-time" v-if="item.timestamp">
                        {{ formatTime(item.timestamp) }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import MarkdownIt from 'markdown-it'
import mdKatex from '@traptitech/markdown-it-katex'
import hljs from 'highlight.js'

const mdi = new MarkdownIt({
    linkify: true,
    highlight(code, language) {
        const validLang = !!(language && hljs.getLanguage(language))
        if (validLang) {
            return highlightBlock(hljs.highlight(language, code, true).value)
        }
        return highlightBlock(hljs.highlightAuto(code).value)
    },
})

function highlightBlock(str) {
    // return `<pre class="code-block-wrapper"><div class="code-block-header"><span class="code-block-header_lang">123123</span><span class="code-block-header_copy">复制</span></div><code class="hljs code-block-body ">${str}</code></pre>`
    return `<pre class="dark code-block-wrapper "><code class="hljs code-block-body ">${str}</code></pre>`
}

export default {
    props: {
        contentList: {
            type: Array
        }
    },
    data() {
        return {

        };
    },
    created() {
    },
    methods: {
        mdIt(text) {
            return mdi.render(text)
        },
        formatTime(timestamp) {
            if (!timestamp) return '';
            const date = new Date(timestamp);
            const now = new Date();
            const diff = now - date;
            
            const hours = date.getHours().toString().padStart(2, '0');
            const minutes = date.getMinutes().toString().padStart(2, '0');
            
            if (diff < 60000) {
                return '刚刚';
            } else if (diff < 3600000) {
                const mins = Math.floor(diff / 60000);
                return `${mins}分钟前`;
            } else if (date.toDateString() === now.toDateString()) {
                return `${hours}:${minutes}`;
            } else {
                const month = (date.getMonth() + 1).toString().padStart(2, '0');
                const day = date.getDate().toString().padStart(2, '0');
                return `${month}-${day} ${hours}:${minutes}`;
            }
        }
    }
};
</script>

<style lang="less" scoped>
@contentWidth: 700px;

.chat-container {
    padding: 20px 10px;
    max-width: @contentWidth;
    margin: 0 auto;
}

.message-wrapper {
    display: flex;
    margin-bottom: 20px;
    animation: messageSlideIn 0.3s ease-out;
    
    &.ai-message {
        justify-content: flex-start;
    }
    
    &.user-message {
        justify-content: flex-end;
    }
}

.message-content {
    display: flex;
    align-items: flex-start;
    max-width: 80%;
}

.ai-message .message-content {
    flex-direction: row;
}

.user-message .message-content {
    flex-direction: row-reverse;
}

.avatar {
    min-width: 40px;
    width: 40px;
    height: 40px;
    line-height: 40px;
    text-align: center;
    border-radius: 4px;
    font-size: 14px;
    font-weight: bold;
    color: #fff;
    flex-shrink: 0;
    margin: 0 10px;
    background-image: linear-gradient(135deg, #778dfc, #3D73E9);
}

.user-avatar {
    background-image: linear-gradient(135deg, #41434F, #2D2F3A);
}

.message-body {
    display: flex;
    flex-direction: column;
    max-width: calc(100% - 60px);
}

.message-bubble {
    padding: 12px 16px;
    border-radius: 8px;
    font-size: 15px;
    line-height: 1.6;
    word-wrap: break-word;
    word-break: break-word;
    position: relative;
    transition: all 0.3s ease;
    
    p {
        margin: 0;
        padding: 0;
    }
    
    pre {
        background: rgba(0, 0, 0, 0.05);
        padding: 10px;
        border-radius: 4px;
        overflow-x: auto;
        margin: 8px 0;
    }
    
    code {
        background: rgba(0, 0, 0, 0.05);
        padding: 2px 6px;
        border-radius: 3px;
        font-family: 'Courier New', monospace;
    }
}

.ai-bubble {
    background: #f5f5f5;
    color: #333;
    border-top-left-radius: 2px;
    margin-left: 0;
    
    &::before {
        content: '';
        position: absolute;
        left: -8px;
        top: 12px;
        width: 0;
        height: 0;
        border-top: 6px solid transparent;
        border-bottom: 6px solid transparent;
        border-right: 8px solid #f5f5f5;
    }
}

.user-bubble {
    background: linear-gradient(135deg, #778dfc, #3D73E9);
    color: #fff;
    border-top-right-radius: 2px;
    margin-right: 0;
    
    &::before {
        content: '';
        position: absolute;
        right: -8px;
        top: 12px;
        width: 0;
        height: 0;
        border-top: 6px solid transparent;
        border-bottom: 6px solid transparent;
        border-left: 8px solid #3D73E9;
    }
    
    p {
        color: #fff;
    }
}

.message-time {
    font-size: 12px;
    color: #999;
    margin-top: 6px;
    text-align: center;
    opacity: 0.8;
}

.ai-message .message-time {
    text-align: left;
    margin-left: 60px;
}

.user-message .message-time {
    text-align: right;
    margin-right: 60px;
}

.typing-indicator {
    display: inline-block;
    animation: typing 1.2s ease-in-out infinite;
}

@keyframes typing {
    0%, 100% {
        opacity: 0.3;
    }
    50% {
        opacity: 1;
    }
}

@keyframes messageSlideIn {
    from {
        opacity: 0;
        transform: translateY(10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@media (max-width: 768px) {
    .chat-container {
        padding: 15px 8px;
    }
    
    .message-content {
        max-width: 90%;
    }
    
    .message-bubble {
        font-size: 14px;
        padding: 10px 14px;
    }
    
    .avatar {
        width: 36px;
        height: 36px;
        line-height: 36px;
        font-size: 13px;
    }
    
    .ai-message .message-time {
        margin-left: 56px;
    }
    
    .user-message .message-time {
        margin-right: 56px;
    }
}

@media (max-width: 480px) {
    .message-content {
        max-width: 95%;
    }
    
    .avatar {
        width: 32px;
        height: 32px;
        line-height: 32px;
        font-size: 12px;
    }
}
</style>