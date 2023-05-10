<template>
  <div class="container">
    <div class="popup" ref="popup" @click="popupClose">
      <div class="con_left" @click.stop>
        <button class="new_talk" @click="newTalk">开始新对话{{ type }}</button>

        <div class="talk_list">
          <div v-for="item in talkList" @click="reTalk(item)" :class="{ 'border': tid == item.id }">
            <span>{{ item.data[(item.data.length - 2)].content }}</span>
            <i class="el-icon-s-comment"></i>
          </div>
        </div>

        <div class="other">
          <div class="bar" @click="reward = true">
            <span>打赏作者</span>
            <i class="el-icon-arrow-right"></i>
          </div>
          <!-- <div class="bar" @click="wxCode = true">
            <span>微信小程序</span>
            <i class="el-icon-arrow-right"></i>
          </div> -->
          <div class="bar" @click="dialogVisible = true">
            <span>免责声明</span>
            <i class="el-icon-arrow-right"></i>
          </div>
        </div>

        <div class="copyright">
          <img src="https://foruda.gitee.com/avatar/1677159626142702590/9019412_luvi_1638684013.png!avatar200" alt=""
            srcset="">
          <div>
            <H2>luvi</H2>
            <p>Star on <a href="https://gitee.com/luvi">Gitee</a></p>
          </div>
        </div>
      </div>
    </div>

    <div class="con_right" ref="con_right">
      <div class="header" ref="header">
        <div class="more_button" @click="popupShow"><i class="el-icon-s-operation"></i></div>
        <!-- <img src="../../assets/images/aslogo.png" alt="" srcset=""> -->
        <span>AI Scene</span>
      </div>
      <div class="content">
        <div class="limit" v-if="messages.length <= 0">
          <div class="primary_con">
            <div class="">
              <i class="el-icon-connection"></i>
              <h3>AI能力</h3>
              <p @click="assign('scene是什么意思')">scene是什么意思</p>
              <p @click="assign('莲藕排骨汤怎么做')">莲藕排骨汤怎么做</p>
              <p @click="assign('今天的世界有哪些新闻热点')">今天的新闻热点</p>
              <p @click="assign('查询xx星座运势')">查询星座运势</p>
              <p @click="assign('有趣的科学实验')">有趣的科学实验</p>
              <p @click="assign('全球高分电影推荐')">全球高分电影推荐</p>
              <p>
                <i class="el-icon-more"></i>
              </p>
            </div>
            <div class="">
              <i class="el-icon-chat-line-square"></i>

              <h3>AI办公</h3>
              <p @click="assign('文章润色')">文章润色</p>
              <p @click="assign('写一篇方案报告')">写一篇方案报告</p>
              <p @click="assign('生成一篇关于xx的日报/周报')">生成一篇日报/周报</p>
              <p @click="assign('撰写一篇邮件/演讲稿')">撰写一篇邮件/演讲稿</p>
              <p @click="assign('代码报错解决')">代码报错解决</p>
              <p>
                <i class="el-icon-more"></i>
              </p>
            </div>
          </div>
          <div class="tip">更多AI能力等你来探索！</div>
        </div>

        <div class="content_list" ref="scrollDiv">
          <div class="talk_con">
            <contentList :contentList="messages"></contentList>
          </div>
        </div>
      </div>
      <div class="footer">
        <div class="input_con">
          <el-input type="textarea" :rows="3" :placeholder="disabled ? '获取中...' : '发送消息给AI'" v-model="content"
            @keyup.enter="send()"></el-input>
          <div class="sub_btn" @click="send()">
            <i v-if="!disabled" class="el-icon-s-promotion"></i>
            <i v-else class="el-icon-loading"></i>
          </div>
        </div>
        <p>Based on OpenAI API (gpt-3.5-turbo) 仅供学习 AI 使用，使用前请知晓 <span @click="dialogVisible = true">免责申明</span></p>
      </div>
    </div>

    <el-dialog style="margin-top: -100px;" title="免责申明" :visible.sync="dialogVisible" width="80%"
      :before-close="handleClose">
      <div class="grid-content content">
        本服务仅供个人学习、学术研究目的使用，未经许可，请勿分享、传播输入及生成的文本、图片内容。您在从事与本服务相关的所有行为(包括但不限于访问浏览、利用、转载、宣传介绍)时，必须以善意且谨慎的态度行事；您确保不得利用本服务故意或者过失的从事危害国家安全和社会公共利益、扰乱经济秩序和社会秩序、侵犯他人合法权益等法律、行政法规禁止的活动，并确保自定义输入文本不包含以下违反法律法规、政治相关、侵害他人合法权益的内容：
        <br>反对宪法所确定的基本原则的； <br>危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；<br> 损害国家荣誉和利益的；<br>
        歪曲、丑化、亵渎、否定英雄烈士事迹和精神，以侮辱、诽谤或者其他方式侵害英雄烈士的姓名、肖像、名誉、荣誉的；<br> 宣扬恐怖主义、极端主义或者煽动实施恐怖活动、极端主义活动的； <br>
        煽动民族仇恨、民族歧视，破坏民族团结的； <br> 破坏国家宗教政策，宣扬邪教和封建迷信的； <br> 散布谣言，扰乱经济秩序和社会秩序的； <br>
        散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的； <br> 侮辱或者诽谤他人，侵害他人名誉、隐私和其他合法权益的； <br>
        含有虚假、有害、胁迫、侵害他人隐私、骚扰、侵害、中伤、粗俗、猥亵、或其它道德上令人反感的内容 <br> 中国法律、法规、规章、条例以及任何具有法律效力之规范所限制或禁止的其它内容。 <br><br>
        1.您确认使用本服务时输入的内容将不包含您的个人信息。您同意并承诺，在使用本服务时，不会披露任何保密、敏感或个人信息。 <br><br>
        2.您确认并知悉本服务生成的所有内容都是由人工智能模型生成，所以可能会出现意外和错误的情况，请确保检查事实。我们对其生成内容的准确性、完整性和功能性不做任何保证，并且其生成的内容不代表我们的态度或观点，仅为提供更多信息，也不构成任何建议或承诺。对于您根据本服务提供的信息所做出的一切行为，除非另有明确的书面承诺文件，否则我们不承担任何形式的责任。
        <br><br> 3.本服务来自于法律法规允许的包括但不限于公开互联网等信息积累，因互联网的开放性属性，不排除其中部分信息具有瑕疵、不合理或引发不快。 <br><br>
        4.不论在何种情况下，本网站均不对由于网络连接故障，电力故障，罢工，劳动争议，暴乱，起义，骚乱，火灾，洪水，风暴，爆炸，不可抗力，战争，政府行为，国际、国内法院的命令，黑客攻击，互联网病毒，网络运营商技术调整，政府临时管制或任何其他不能合理控制的原因而造成的本服务不能访问、服务中断、信息及数据的延误、停滞或错误，不能提供或延迟提供服务而承担责任。
        <br><br>
        5.当本服务以链接形式推荐其他网站内容时，我们并不对这些网站或资源的可用性负责，且不保证从这些网站获取的任何内容、产品、服务或其他材料的真实性、合法性。在法律允许的范围内，本网站不承担您就使用本服务所提供的信息或任何链接所引致的任何直接、间接、附带、从属、特殊、继发、惩罚性或惩戒性的损害赔偿。
      </div>
      <span slot="footer" class="dialog-footer">
        <!-- <el-button @click="dialogVisible = false">取 消</el-button> -->
        <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 打赏 -->
    <el-dialog style="margin-top: -100px;" title="打赏作者" :visible.sync="reward" width="500px" :before-close="handleClose">
      <p class="context">本平台是一个基于gpt-3.5-turbo的<span style="color: #2e8cff;">免费</span>的人工智能应用平台，可进行智能对话、翻译、创作、学习以及趣味问答等。
      </p>
      <img style="width: 40%;" src="../../assets/images/wx.png">
      <img style="width: 40%;" src="../../assets/images/zfb.jpg">
      <span slot="footer" class="dialog-footer">
        <!-- <el-button @click="dialogVisible = false">取 消</el-button> -->
        <el-button type="primary" @click="reward = false">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 微信小程序 -->
    <el-dialog style="margin-top: -100px;" title="扫码体验官方微信小程序" :visible.sync="wxCode" width="500px"
      :before-close="handleClose">
      <p class="context">本平台是一个基于gpt-3.5-turbo的<span style="color: #2e8cff;">免费</span>的人工智能应用平台，可进行智能对话、翻译、创作、学习以及趣味问答等。
      </p>
      <img style="width: 100%;margin-top: 20px;" src="../../assets/images/gh_9255934cf8be_430.jpg">
    </el-dialog>
  </div>
</template>

<script>
import { openChat } from "@/api/api";
import md5 from 'js-md5'
import contentList from "./components/content-list.vue"

export default {
  name: "AI",
  components: {
    contentList
  },
  data() {
    return {
      // 内容
      content: "",
      messages: [],
      disabled: false,
      dialogVisible: false,
      //  打赏弹窗
      reward: false,
      //
      wxCode: false,
      talkList: [],
      tid: localStorage.getItem("talkId"),
      type: this.$route.query.type
    };
  },
  created() {
    this.messages = localStorage.getItem("messages") ? JSON.parse(localStorage.getItem("messages")) : []
    this.talkList = localStorage.getItem("talkList") ? JSON.parse(localStorage.getItem("talkList")) : []

    let arr = [{ "topic": null, "describe": null, "annotation": null, "fileUrl": null, "status": 0, "allScore": 0, "stuGraScoreList": [] }]

    console.log(arr[0].allScore);
    setTimeout(_ => {
      this.handleScrollBottom() //滚动至最底部
    }, 100)

  },
  mounted() {
    if (this.type == 'app') {
      this.$refs.header.style = "display:none"
      this.$refs.scrollDiv.style = "margin-top:-35px"
    }
  },
  methods: {
    send() {
      this.handleScrollBottom()
      if (!this.content) {
        return
      }
      this.disabled = true
      let timeStamp = this.getTimeStamp()
      let user = {
        "role": "user",
        "content": this.content.trim()
      }
      let system = {
        "role": "assistant",
        "content": "wait"
      }
      this.messages.push(user)
      this.messages.push(system)

      let format = this.content.trim() + timeStamp
      let sign = md5(format)

      this.content = ""
      this.handleScrollBottom() //滚动至最底部

      let req = {
        messages: this.messages.slice(0, -1),
        // model: "gpt-3.5-turbo",
        sign: sign,
        timestamp: timeStamp
      }

      openChat(req).then(res => {
        let data
        if (res.data.indexOf('"error": {') != -1) {
          data = JSON.parse(res.data).error.message
        } else {
          data = res.data
        }

        // data = res.data.indexOf('"error": {') != -1 ? "获取失败，请重试，或重新开启对话！" : res.data
        this.messages[(this.messages.length - 1)].content = data
        this.handleScrollBottom() //滚动至最底部
        this.disabled = false

      }, error => {
        this.messages[(this.messages.length - 1)].content = "服务器繁忙，请重新尝试"
        this.handleScrollBottom() //滚动至最底部
        this.disabled = false
      })
    },
    getTimeStamp() {
      let dateNow = new Date()
      let nowTime = dateNow.getTime()
      return nowTime
    },
    handleScrollBottom() {
      this.$nextTick(() => {
        let scrollElem = this.$refs.scrollDiv;
        scrollElem.scrollTo({ top: scrollElem.scrollHeight, behavior: 'smooth' });
      });
      localStorage.setItem("messages", JSON.stringify(this.messages))
    },
    handleClose(done) {
      done();
    },
    popupShow() {
      this.$refs.popup.style = 'left:0;background: rgba(0, 0, 0, 0.5)'
    },
    popupClose() {
      this.$refs.popup.style = 'left:-100vw'
    },
    assign(text) {
      this.content = text
    },
    // 保存历史数据据
    saveHistory() {
      let obj = {
        id: 'scene' + this.getTimeStamp(),
        data: this.messages
      }
      if (this.messages.length > 0) {
        if (localStorage.getItem("talkId")) {
          this.talkList.map(item => {
            if (item.id == localStorage.getItem("talkId")) {
              item.data = this.messages
            }
          })
        } else {
          this.talkList.unshift(obj)
        }
        localStorage.removeItem("talkId")
        this.tid = ''
        this.talkList = this.talkList.slice(0, 8)
        localStorage.setItem("talkList", JSON.stringify(this.talkList))
      }
    },
    newTalk() {
      this.saveHistory()

      this.messages = []
      localStorage.setItem("messages", JSON.stringify([]))
      this.popupClose()
    },
    reTalk(item) {
      this.saveHistory()

      localStorage.setItem("talkId", item.id)
      this.tid = item.id
      this.messages = item.data
      this.popupClose()
      setTimeout(_ => {
        this.handleScrollBottom() //滚动至最底部
      }, 100)
    }
  }
};
</script>

<style lang="less" scoped>
@contentWidth: 800px;
@themeColor: #4684ff;
// @themeColor: #4684ff;
@commonColor: #eee;
@themeRadius: 6px;



.container {
  display: flex;
  justify-content: space-between;
  height: 100vh;
  width: 100vw;
  overflow: hidden;
  min-width: 100px;
  transition: 0.6s;
  background-image: url("https://luvi.gitee.io/ai/publicImages/login_background.c41c40af.png");
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
  backdrop-filter: blur(10px);
}

.con_left {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  // justify-content: center;
  min-width: 250px;
  max-width: 250px;
  background: rgba(255, 255, 255, 1);
  height: 100%;
  padding: 20px 0;
  box-sizing: border-box;
  transition: 0.5s;

  .talk_list {
    width: 80%;
    margin-top: 10px;
    color: #4c4c4c;

    .border {
      border: 1px solid #778dfc;
      background: #f2f6ff;

      color: #6e86ff;

      &:hover {
        background: #f0f4ff;
      }

      // font-weight: bold;
    }


    div {
      display: flex;
      justify-content: space-between;
      align-items: center;
      height: 45px;
      border: 1px solid #eee;
      border-radius: 6px;
      padding: 0 15px 0 15px;
      font-size: 14px;
      box-sizing: border-box;
      cursor: pointer;
      margin-top: 10px;
      color: #595959;

      span {
        display: inline-block;
        text-align: left;
        width: 80%;
        overflow: hidden;
        word-break: break-all;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 1;
      }

      &:hover {
        background-image: linear-gradient(to right, #eee, #eee);
      }
    }
  }

  .copyright {
    position: absolute;
    bottom: 15px;
    width: 90%;
    border: 1px solid #eee;
    display: flex;
    align-items: center;
    padding: 10px;
    box-sizing: border-box;
    border-radius: 8px;

    img {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      margin-right: 10px;
    }

    div {
      color: #424242;

      h2 {
        font-size: 15px;
      }
    }

    p {
      font-size: 13px;
      margin-top: 2px;
    }

    a {
      color: #266dfb;
      font-weight: normal !important;
    }
  }

  .new_talk {
    border: none;
    width: 80%;
    height: 45px;
    font-weight: bold;
    letter-spacing: 1px;
    margin-bottom: 16px;
    background-image: linear-gradient(to right, #778dfc, #3D73E9);

    border-radius: @themeRadius;
    box-shadow: 0px 3px 8px 0px rgba(0, 0, 0, 0.08);
    color: #fff;
    cursor: pointer;
    transition: 0.2s;

    &:hover {
      background-image: linear-gradient(to right, #6b83fb, #3d8de4);
    }

    &:active {
      background-image: linear-gradient(to right, #6b83fb, #3d8de4);
    }
  }

  .other {
    position: absolute;
    bottom: 90px;
    width: 90%;
    border-radius: 6px;
    overflow: hidden;

    .bar {
      line-height: 45px;
      // border-bottom: 1px solid #ddd;
      font-weight: bold;
      // background: #eeeeee;
      color: #5a5a5a;
      box-sizing: border-box;
      cursor: pointer;
      font-size: 14px;
      padding: 0 15px;
      display: flex;
      align-items: center;
      justify-content: space-between;

      &:hover {
        background: #eee;
      }

      &:nth-child(3) {
        border: none;
      }
    }
  }
}

.con_right {
  position: relative;
  min-width: 800px;
  width: 100%;
  height: 100%;
  // background: #ECEFF6;
  // background-image: linear-gradient(45deg, #f6f8ff, #E2E8FF);


  .header {
    position: absolute;
    z-index: 1;
    width: 100%;
    display: flex;
    display: none;
    align-items: center;
    justify-content: center;
    background-image: linear-gradient(to left, #5185ff, 1px, #5185ff);
    backdrop-filter: blur(8px);
    height: 45px;

    span {
      font-size: 16px;
      text-align: center;
      color: #ffffff;
      font-weight: bold;
    }

    img {
      width: 140px;
    }

    .more_button {
      display: none;
      position: absolute;
      left: 15px;
      font-size: 23px;
      width: 35px;
      height: 35px;
      color: #fff;
      text-align: center;
      line-height: 35px;

      &:active {
        background: rgba(0, 0, 0, 0.1);
        border-radius: 3px;
      }
    }
  }

  .content {
    width: 100%;

    .limit {
      margin: auto;
      width: @contentWidth;
      margin-top: 60px;
    }

    .tip {
      padding-left: 6px;
      border-left: 3px solid #266dfb;
      margin-left: 20px;
      box-sizing: border-box;
      font-size: 14px;
      color: #4a4a4a;
    }

    .primary_con {
      padding: 20px 10px;
      box-sizing: border-box;
      display: flex;
      justify-content: center;
      text-align: center;

      h3 {
        margin-bottom: 15px;
        color: #303030;
      }

      div {
        width: 50%;
        padding: 10px;
        box-sizing: border-box;
      }

      p {
        line-height: 35px;
        margin-top: 10px;
        background: #f7f7f8;
        border-radius: 5px;
        font-size: 13px;
        color: #4a4a4a;
        cursor: pointer;

        &:hover {
          background: #e9e9ea;
        }

        &:active {
          background: #d6d6d6;
        }

        i {
          font-size: 15px;
        }
      }

      i {
        font-size: 26px;
      }
    }

    .content_list {
      width: calc(100%);
      padding-top: 50px;
      padding-bottom: 170px;
      // padding-left: 3px;
      box-sizing: border-box;
      overflow: scroll;
      height: calc(100vh);
      overflow-x: hidden;
    }

    .talk_con {
      margin: auto;
      width: calc(@contentWidth);
    }
  }


  // footer总高度175px
  .footer {
    position: absolute;
    // background: #ECEFF6;
    // padding-top: 30px;
    // background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0), 3%, #ECEFF6);
    backdrop-filter: blur(20px);

    bottom: 0px;
    width: 100%;

    .input_con {
      position: relative;
      margin: auto;
      width: @contentWidth + 100px;

      .sub_btn {
        position: absolute;
        right: 10px;
        line-height: 38px;
        border-radius: 5px;
        bottom: 10px;
        width: 38px;
        text-align: center;
        color: #fff;
        cursor: pointer;
        transition: 0.2s;
        font-size: 21px;
        background-image: linear-gradient(to right, #778dfc, #3D73E9);


        &:hover {
          background-image: linear-gradient(to right, #778dfc, #6178ec);
        }
      }

      // .el-input {
      //   position: absolute;
      //   top: 0;
      //   left: 0;
      //   box-sizing: border-box;
      //   border: 1px solid #e9e9e9;
      //   width: 100%;
      //   line-height: 45px;
      //   padding: 0 45px 0 15px;
      //   border-radius: 6px;
      //   // height: 50px;
      //   transition: 0.3s;
      //   letter-spacing: 0.5px;
      //   color: #383838;
      //   box-shadow: 0px 3px 8px 0px rgba(0, 0, 0, 0.02);

      //   &:focus {
      //     outline: none;
      //     border: 1px solid @themeColor;
      //     box-shadow: 0px 0px 8px 0px rgba(0, 0, 0, 0.03);
      //   }
      // }

      /deep/ .el-textarea__inner {
        box-shadow: 0px 3px 8px 0px rgba(0, 0, 0, 0.02);
        border-radius: 8px;
        font-family: 'black';
        padding: 10px 10px;
        box-sizing: border-box;

        &:focus {
          outline: none;
          border: 1px solid @themeColor;
          box-shadow: 0px 0px 8px 0px rgba(0, 0, 0, 0.03);
        }
      }



    }

    p {
      margin-top: 15px;
      margin-bottom: 20px;
      box-sizing: border-box;
      font-size: 10px;
      color: #909090;
      text-align: center;

      span {
        text-decoration: underline;
        color: @themeColor;
        cursor: pointer;
      }
    }
  }

}

/* android适配css 从下开始 */
@media (max-width: 800px) {

  .popup {
    position: absolute;
    left: -100vw;
    z-index: 4;
    height: 100%;
    width: 100vw;
    transition: 0.5s;

  }

  .con_left {
    max-width: 200px;

  }

  .con_right {
    min-width: 100%;

    .limit {
      max-width: 100%;
    }

    .header {
      display: block;
      display: flex;
      background-image: linear-gradient(to right, #778dfc, #3D73E9);

    }

    .more_button {
      display: block !important;
      color: #fff !important;
    }

    .talk_con {
      max-width: 100%;
    }
  }

  .input_con {
    max-width: 95%;
  }

  .content_list {
    max-width: calc(100% - 30px);
    margin: auto;
  }

  /deep/ .el-dialog {
    width: 85% !important;
  }
}
</style>
