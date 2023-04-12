<template>
    <div style="padding-bottom: 10px;">
        <div :class="{ 'card': true, 'cardFlexEnd': item.role == 'user', 'sysDialog': item.role !== 'user' }"
            v-for="(item, i) in contentList" :key="i">
            <!-- <img v-if="item.role !== 'user'" src="../../../assets/images/ai.png" alt="" srcset=""> -->
            <div class="miIcon" v-if="item.role == 'user'">
                U
            </div>
            <div class="miIcon ai" v-if="item.role !== 'user'">
                AI
            </div>
            <div v-if="item.content && item.content !== 'wait'"
                :class="{ 'context': true, 'commonDialog': item.role == 'user' }" v-html="mdIt(item.content)">
            </div>
            <div v-if="item.content == 'wait'" :class="{ 'context': true }">
                <span class="point-flicker"><i class="el-icon-more"></i></span>
            </div>
            <!-- <img style="width:0" v-if="item.role == 'user'"
                src="https://bjb.openstorage.cn/v1/yjcbb/public/profile/1571207145304_944060.jpg" alt="" srcset=""> -->
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
        }
    }
};
</script>

<style lang="less" scoped>
@contentWidth: 700px;
@themeColor: #fff;
@commonColor: rgba(0, 0, 0, 0);
@themeRadius: 8px;




.sysDialog {
    background: @themeColor;
    color: #41434F;
    border-radius: @themeRadius;
    box-shadow: 0px 5px 10px 0px rgba(57, 59, 60, 0.06) !important;
    cursor: pointer;
    transition: 0.3s;

    &:hover {
        box-shadow: 0px 0px 20px 0px rgba(57, 59, 60, 0.03) !important;

    }
}

.commonDialog {
    background: @commonColor;
    color: #41434F !important;
    // box-shadow: 0px 3px 8px 0px rgba(0, 0, 0, 0.03) !important;
    cursor: pointer;
    transition: 0.3s;

    &:hover {
        // background: rgba(57, 59, 60, 0.2);
    }
}

.cardFlexEnd {
    // justify-content: flex-end;
    // margin-right: 10px;
}

.card {
    position: relative;
    display: flex;
    margin-bottom: 15px;
    transform: 0.3s;
    font-family: 'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;


    &:hover {
        transition: all 0.3s ease;
        transform: scale(1.005);
    }


    img {
        padding: 7px;
        width: 40px;
        height: 40px;
        border-radius: @themeRadius;
        box-sizing: border-box;
        margin: 5px 10px;
    }

    .context {
        box-sizing: border-box;
        line-height: 25px;
        // min-width: 60px;
        max-width: calc(100% - 70px);
        padding: 15px 0px 15px 0px;
        font-size: 14px;
        // box-shadow: 0px 3px 8px 0px rgba(0, 0, 0, 0.08);
        // white-space: pre-wrap;
    }
}

/* 设置动画 */
.point-flicker {
    display: inline-block;
    // font-size: 20px;
    height: 100%;
    animation: warn 1.2s ease-out 0s infinite;
}

@keyframes warn {
    0% {
        opacity: 1;
    }

    25% {
        opacity: 0.25;
    }

    50% {
        opacity: 0.5;
    }

    75% {
        opacity: 0.75;
    }

    100% {
        opacity: 1;
    }
}

.miIcon {
    min-width: 30px;
    margin: 12px;
    height: 30px;
    line-height: 30px;
    text-align: center;
    background: #414141;
    box-sizing: border-box;
    border-radius: 5px;
    font-size: 13px;
    color: #fff;
}

.ai {
    background-image: linear-gradient(to right, #778dfc, #3D73E9) !important;
}
</style>