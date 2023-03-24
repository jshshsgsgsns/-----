<template>
    <div style="padding-bottom: 10px;">
        <div :class="{ 'card': true, 'cardFlexEnd': item.role == 'user' }" v-for="(item, i) in contentList" :key="i">
            <img v-if="item.role !== 'user'" src="../../../assets/images/ai.png" alt="" srcset="">
            <div v-if="item.content.trim() !== 'wait'"
                :class="{ 'context': true, 'sysDialog': item.role !== 'user', 'commonDialog': item.role == 'user' }"
                v-html="item.content.trim()">
            </div>
            <div v-if="item.content.trim() == 'wait'"
                :class="{ 'context': true, 'sysDialog': item.role !== 'user', 'commonDialog': item.role == 'user' }">
                <span class="point-flicker"><i class="el-icon-more"></i></span>
            </div>
            <!-- <img style="width:0" v-if="item.role == 'user'"
                src="https://bjb.openstorage.cn/v1/yjcbb/public/profile/1571207145304_944060.jpg" alt="" srcset=""> -->
        </div>
    </div>
</template>

<script>
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
    }
};
</script>

<style lang="less" scoped>
@contentWidth: 700px;
@themeColor: #4684ff;
@commonColor: #eee;
@themeRadius: 5px;

.sysDialog {
    background: @themeColor;
}

.commonDialog {
    background: @commonColor;
    color: rgb(68, 68, 68) !important;
    box-shadow: 0px 3px 8px 0px rgba(0, 0, 0, 0.03) !important;
}

.cardFlexEnd {
    justify-content: flex-end;
    margin-right: 10px;
}

.card {
    display: flex;
    margin-bottom: 18px;

    img {
        padding: 7px;
        width: 40px;
        height: 40px;
        border-radius: @themeRadius;
        box-sizing: border-box;
        margin: 0 10px;
    }

    .context {
        box-sizing: border-box;
        line-height: 26px;
        // min-width: 60px;
        max-width: calc(100% - 90px);
        padding: 6px 15px 6px 15px;
        color: #fff;
        border-radius: @themeRadius;
        font-size: 14px;
        box-shadow: 0px 3px 8px 0px rgba(0, 0, 0, 0.08);
        white-space: pre-wrap;
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
</style>