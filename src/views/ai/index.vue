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
          <!-- <div class="bar" @click="wxCode = true">
            <span>微信小程序</span>
            <i class="el-icon-arrow-right"></i>
          </div> -->
        </div>

        <div class="copyright">
          <img src="../../assets/images/aslogo.png" alt="三亚孟天涯公司" srcset="">
          <div>
            <H2>三亚孟天涯公司</H2>
            <p>专业酒店管理解决方案提供商</p>
          </div>
        </div>
      </div>
    </div>

    <div class="con_right" ref="con_right">
      <div class="header" ref="header">
        <div class="more_button" @click="popupShow"><i class="el-icon-s-operation"></i></div>
        <!-- <img src="../../assets/images/aslogo.png" alt="" srcset=""> -->
        <span>酒店管理ai助手</span>
        <!-- 登录/用户信息区域 -->
        <div class="auth_buttons">
          <!-- 登录按钮 -->
          <el-button v-if="!isLoggedIn" type="primary" class="login_btn" @click="showLogin">登录</el-button>
          <!-- 已登录用户信息 -->
          <div v-else class="user_info" @click="showUserProfile">
            <span class="user_name">{{ currentUser.username }}</span>
            <i class="el-icon-caret-bottom"></i>
          </div>
        </div>
      </div>
      <div class="content">
        <div class="limit" v-if="messages.length <= 0">
          <div class="hotel_management_title">
            <i class="el-icon-hotel"></i>
            <h2>AI酒店管理</h2>
          </div>
          
          <div class="hotel_management_con">
            <!-- 酒店管理推荐 -->
            <div class="hotel_module">
              <div class="module_header" @click="toggleModule('roomManagement')">
                <i class="el-icon-s-home"></i>
                <h3>酒店管理推荐</h3>
                <i :class="{'el-icon-arrow-down': !expandedModules.roomManagement, 'el-icon-arrow-up': expandedModules.roomManagement}"></i>
              </div>
              <div v-if="expandedModules.roomManagement" class="module_content">
                <div class="recommendation_grid">
                  <div class="recommendation_item" @click.stop="assign('酒店运营管理策略')">
                    <div class="recommendation_icon">
                      <i class="el-icon-s-operation"></i>
                    </div>
                    <div class="recommendation_info">
                      <h4>酒店运营管理策略</h4>
                      <p>基于行业最佳实践的运营管理方法</p>
                    </div>
                  </div>
                  <div class="recommendation_item" @click.stop="assign('客户服务管理方法')">
                    <div class="recommendation_icon">
                      <i class="el-icon-star-off"></i>
                    </div>
                    <div class="recommendation_info">
                      <h4>客户服务管理方法</h4>
                      <p>提升客户满意度的服务管理策略</p>
                    </div>
                  </div>
                  <div class="recommendation_item" @click.stop="assign('团队管理最佳实践')">
                    <div class="recommendation_icon">
                      <i class="el-icon-user"></i>
                    </div>
                    <div class="recommendation_info">
                      <h4>团队管理最佳实践</h4>
                      <p>高效团队建设与人员管理策略</p>
                    </div>
                  </div>
                  <div class="recommendation_item" @click.stop="assign('成本控制与优化')">
                    <div class="recommendation_icon">
                      <i class="el-icon-coin"></i>
                    </div>
                    <div class="recommendation_info">
                      <h4>成本控制与优化</h4>
                      <p>降低运营成本的管理策略与方法</p>
                    </div>
                  </div>
                  <div class="recommendation_item" @click.stop="assign('市场营销策略')">
                    <div class="recommendation_icon">
                      <i class="el-icon-s-marketing"></i>
                    </div>
                    <div class="recommendation_info">
                      <h4>市场营销策略</h4>
                      <p>提升品牌影响力的营销管理方法</p>
                    </div>
                  </div>
                  <div class="recommendation_item" @click.stop="assign('质量管理与改进')">
                    <div class="recommendation_icon">
                      <i class="el-icon-medal"></i>
                    </div>
                    <div class="recommendation_info">
                      <h4>质量管理与改进</h4>
                      <p>持续提升服务质量的管理体系</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
          </div>
          <div class="tip">更多AI酒店管理能力等你来探索！</div>
        </div>

        <div class="content_list" ref="scrollDiv">
          <div class="talk_con">
            <contentList :contentList="messages"></contentList>
          </div>
        </div>
      </div>
      <div class="footer">
        <div class="input_con">
          <el-input type="textarea" :rows="3" :placeholder="disabled ? '获取中...' : '发送消息给AI'" v-model="content" @keyup.enter="send()"></el-input>
          <div class="sub_btn" @click="send()">
            <i v-if="!disabled" class="el-icon-s-promotion"></i>
            <i v-else class="el-icon-loading"></i>
          </div>
        </div>
        <p>三亚梦天涯公司，主营酒店管理、旅游服务及电竞酒店运营</p>
      </div>
    </div>

    <!-- 微信小程序 -->
    <el-dialog style="margin-top: -100px;" title="扫码体验官方微信小程序" :visible.sync="wxCode" width="500px" :before-close="handleClose">
      <p class="context">本平台是一个基于gpt-3.5-turbo的<span style="color: #2e8cff;">免费</span>的人工智能应用平台，可进行智能对话、翻译、创作、学习以及趣味问答等。
      </p>
      <img style="width: 100%;margin-top: 20px;" src="../../assets/images/gh_9255934cf8be_430.jpg">
    </el-dialog>
    
    <!-- 登录弹窗 -->
    <el-dialog title="用户登录" :visible.sync="loginVisible" width="400px" :before-close="handleClose">
      <el-form :model="loginForm" :rules="loginRules" ref="loginForm" label-width="80px">
        <el-form-item label="登录账号" prop="loginName">
          <el-input v-model="loginForm.loginName" placeholder="请输入用户名/邮箱/电话号码"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input type="password" v-model="loginForm.password" placeholder="请输入密码" show-password></el-input>
        </el-form-item>
        <el-form-item>
          <div class="forget_password" @click="showForgotPassword">忘记密码</div>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitLogin" :loading="loginLoading" class="login_submit">登录</el-button>
          <el-button @click="resetLoginForm">重置</el-button>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <span class="register_tip">还没有账号？<a href="javascript:void(0)" @click="loginVisible = false; registerVisible = true;">立即注册</a></span>
      </div>
    </el-dialog>
    
    <!-- 用户个人资料弹窗 -->
    <el-dialog title="个人资料" :visible.sync="userProfileVisible" width="500px" :before-close="handleClose">
      <el-form :model="currentUser" :rules="userProfileRules" ref="userProfileForm" label-width="100px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="currentUser.username" disabled></el-input>
        </el-form-item>
        <el-form-item label="酒店名称" prop="hotelName">
          <el-input v-model="currentUser.hotelName" disabled></el-input>
        </el-form-item>
        <el-form-item label="电话号码" prop="phone">
          <el-input v-model="currentUser.phone" placeholder="请输入电话号码"></el-input>
          <el-button type="text" class="verify_phone" @click="verifyPhone">验证</el-button>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="currentUser.email" placeholder="请输入邮箱"></el-input>
          <el-button type="text" class="verify_email" @click="verifyEmail">验证</el-button>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="saveUserProfile" :loading="profileLoading">保存修改</el-button>
          <el-button @click="userProfileVisible = false">取消</el-button>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="danger" @click="logout">退出登录</el-button>
      </div>
    </el-dialog>
    
    <!-- 注册弹窗 -->
    <el-dialog title="用户注册" :visible.sync="registerVisible" width="400px" :before-close="handleClose">
      <el-form :model="registerForm" :rules="registerRules" ref="registerForm" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="registerForm.username" placeholder="请输入用户名"></el-input>
        </el-form-item>
        <el-form-item label="酒店名称" prop="hotelName">
          <el-input v-model="registerForm.hotelName" placeholder="请输入酒店名称"></el-input>
        </el-form-item>
        <el-form-item label="电话号码" prop="phone">
          <el-input v-model="registerForm.phone" placeholder="请输入电话号码（支持国际格式）"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input type="password" v-model="registerForm.password" placeholder="请输入密码" show-password></el-input>
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input type="password" v-model="registerForm.confirmPassword" placeholder="请再次输入密码" show-password></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="registerForm.email" placeholder="请输入邮箱"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitRegister" :loading="registerLoading" class="register_submit">注册</el-button>
          <el-button @click="resetRegisterForm">重置</el-button>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <span class="login_tip">已有账号？<a href="javascript:void(0)" @click="registerVisible = false; loginVisible = true;">立即登录</a></span>
      </div>
    </el-dialog>
    
    <!-- 忘记密码弹窗 -->
    <el-dialog title="忘记密码" :visible.sync="forgotPasswordVisible" width="400px" :before-close="handleClose">
      <div class="forgot_password_content">
        <p class="forgot_password_text">忘记密码请联系负责人：</p>
        <p class="forgot_password_phone">电话号码：<span>16666666666</span></p>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="forgotPasswordVisible = false" type="primary">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { openChat, aiChat, login, register, getUserById, updateUser } from "@/api/api";
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
      //
      wxCode: false,
      talkList: [],
      tid: localStorage.getItem("talkId"),
      type: this.$route.query.type,
      // AI酒店管理模块展开状态
      expandedModules: {
        roomManagement: false
      },
      // 登录注册相关
      loginVisible: false,
      registerVisible: false,
      forgotPasswordVisible: false,
      loginLoading: false,
      registerLoading: false,
      // 登录表单数据
      loginForm: {
        loginName: '', // 支持用户名/邮箱/电话号码登录
        password: ''
      },
      // 登录表单验证规则
      loginRules: {
        loginName: [
          { required: true, message: '请输入登录账号', trigger: 'blur' },
          { min: 3, max: 50, message: '登录账号长度在 3 到 50 个字符', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
        ]
      },
      // 登录状态管理
      isLoggedIn: false,
      currentUser: {
        username: '',
        email: '',
        phone: '',
        hotelName: ''
      },
      // 用户个人资料弹窗
      userProfileVisible: false,
      profileLoading: false,
      // 用户个人资料验证规则
      userProfileRules: {
        phone: [
          { pattern: /^[+]?[0-9]{1,4}[\s-]?[0-9]{1,14}$/, message: '请输入有效的电话号码', trigger: 'blur' }
        ],
        email: [
          { type: 'email', message: '请输入有效的邮箱地址', trigger: 'blur' }
        ]
      },
      // 注册表单数据
      registerForm: {
        username: '',
        hotelName: '',
        phone: '',
        password: '',
        confirmPassword: '',
        email: ''
      },
      // 注册表单验证规则
      registerRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
        ],
        hotelName: [
          { required: true, message: '请输入酒店名称', trigger: 'blur' },
          { min: 2, max: 50, message: '酒店名称长度在 2 到 50 个字符', trigger: 'blur' }
        ],
        phone: [
          { required: true, message: '请输入电话号码', trigger: 'blur' },
          { pattern: /^[+]?[0-9]{1,4}[\s-]?[0-9]{1,14}$/, message: '请输入有效的电话号码（支持国际格式，如：+86 13800138000）', trigger: 'blur' },
          { validator: this.validatePhoneUnique, trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请确认密码', trigger: 'blur' },
          { validator: this.validateConfirmPassword, trigger: 'blur' }
        ],
        email: [
          { required: true, message: '请输入邮箱', trigger: 'blur' },
          { type: 'email', message: '请输入有效的邮箱地址', trigger: 'blur' }
        ]
      }
    };
  },
  created() {
    let savedMessages = localStorage.getItem("messages") ? JSON.parse(localStorage.getItem("messages")) : []
    this.messages = savedMessages.map(msg => ({
      ...msg,
      timestamp: msg.timestamp || this.getTimeStamp() - (savedMessages.length - savedMessages.indexOf(msg)) * 60000
    }))
    this.talkList = localStorage.getItem("talkList") ? JSON.parse(localStorage.getItem("talkList")) : []
    
    // 初始化登录状态
    const isLoggedIn = localStorage.getItem('isLoggedIn')
    if (isLoggedIn === 'true') {
      this.isLoggedIn = true
      const userInfo = localStorage.getItem('currentUser')
      if (userInfo) {
        this.currentUser = JSON.parse(userInfo)
      }
    }

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
        "content": this.content.trim(),
        "timestamp": timeStamp
      }
      let system = {
        "role": "assistant",
        "content": "wait",
        "timestamp": timeStamp
      }
      this.messages.push(user)
      this.messages.push(system)

      let format = this.content.trim() + timeStamp
      let sign = md5(format)

      this.content = ""
      this.handleScrollBottom()

      let req = {
        messages: this.messages.slice(0, -1),
        sign: sign,
        timestamp: timeStamp
      }

      aiChat({
        content: req.messages[req.messages.length - 1].content,
        messages: req.messages.slice(0, -1),
        model: "qwen-turbo",
        temperature: 0.7,
        maxTokens: 2000
      }).then(res => {
        if (res.code === 200) {
          this.messages[(this.messages.length - 1)].content = res.data.content
        } else {
          this.messages[(this.messages.length - 1)].content = res.message || "获取失败，请重试，或重新开启对话！"
        }
        this.handleScrollBottom()
        this.disabled = false
      }, error => {
        this.messages[(this.messages.length - 1)].content = "服务器繁忙，请重新尝试"
        this.handleScrollBottom()
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
    // 切换模块展开/折叠状态（手风琴效果）
    toggleModule(moduleName) {
      // 如果点击的是已展开的模块，则折叠它
      if (this.expandedModules[moduleName]) {
        this.expandedModules[moduleName] = false;
      } else {
        // 否则，先折叠所有模块，再展开当前模块
        Object.keys(this.expandedModules).forEach(key => {
          this.expandedModules[key] = false;
        });
        this.expandedModules[moduleName] = true;
      }
    },
    // 登录注册相关方法
    // 显示登录弹窗
    showLogin() {
      this.loginVisible = true;
    },
    // 显示注册弹窗
    showRegister() {
      this.registerVisible = true;
    },
    // 显示忘记密码弹窗
    showForgotPassword() {
      this.forgotPasswordVisible = true;
    },
    // 验证确认密码
    validateConfirmPassword(rule, value, callback) {
      if (value !== this.registerForm.password) {
        callback(new Error('两次输入的密码不一致'));
      } else {
        callback();
      }
    },
    // 验证电话号码唯一性
    validatePhoneUnique(rule, value, callback) {
      // 这里可以添加电话号码唯一性校验API调用逻辑
      // 模拟验证通过
      callback();
    },
    // 提交登录表单
    submitLogin() {
      this.$refs.loginForm.validate((valid) => {
        if (valid) {
          this.loginLoading = true;
          login({
            loginName: this.loginForm.loginName,
            password: this.loginForm.password
          }).then(res => {
            if (res.code === 200) {
              this.loginLoading = false;
              this.$message.success('登录成功');
              this.loginVisible = false;
              this.isLoggedIn = true;
              this.currentUser = res.data.user;
              localStorage.setItem('isLoggedIn', 'true');
              localStorage.setItem('currentUser', JSON.stringify(res.data.user));
              localStorage.setItem('token', res.data.token);
            } else {
              this.loginLoading = false;
              this.$message.error(res.message || '登录失败');
            }
          }).catch(error => {
            this.loginLoading = false;
            this.$message.error('登录失败，请检查网络连接');
          });
        } else {
          return false;
        }
      });
    },
    // 重置登录表单
    resetLoginForm() {
      this.$refs.loginForm.resetFields();
    },
    // 提交注册表单
    submitRegister() {
      this.$refs.registerForm.validate((valid) => {
        if (valid) {
          this.registerLoading = true;
          register({
            username: this.registerForm.username,
            hotelName: this.registerForm.hotelName,
            phone: this.registerForm.phone,
            password: this.registerForm.password,
            confirmPassword: this.registerForm.confirmPassword,
            email: this.registerForm.email
          }).then(res => {
            if (res.code === 200) {
              this.registerLoading = false;
              this.$message.success('注册成功');
              this.registerVisible = false;
              this.loginVisible = true;
              this.resetRegisterForm();
            } else {
              this.registerLoading = false;
              this.$message.error(res.message || '注册失败');
            }
          }).catch(error => {
            this.registerLoading = false;
            this.$message.error('注册失败，请检查网络连接');
          });
        } else {
          return false;
        }
      });
    },
    // 重置注册表单
    resetRegisterForm() {
      this.$refs.registerForm.resetFields();
    },
    // 显示用户个人资料
    showUserProfile() {
      this.userProfileVisible = true;
    },
    // 保存用户个人资料
    saveUserProfile() {
      this.$refs.userProfileForm.validate((valid) => {
        if (valid) {
          this.profileLoading = true;
          const userId = this.currentUser.id;
          updateUser(userId, {
            hotelName: this.currentUser.hotelName,
            phone: this.currentUser.phone,
            email: this.currentUser.email
          }).then(res => {
            if (res.code === 200) {
              this.profileLoading = false;
              this.$message.success('个人资料保存成功');
              this.currentUser = res.data;
              localStorage.setItem('currentUser', JSON.stringify(this.currentUser));
              this.userProfileVisible = false;
            } else {
              this.profileLoading = false;
              this.$message.error(res.message || '保存失败');
            }
          }).catch(error => {
            this.profileLoading = false;
            this.$message.error('保存失败，请检查网络连接');
          });
        } else {
          return false;
        }
      });
    },
    // 验证电话号码
    verifyPhone() {
      // 这里可以添加电话号码验证API调用逻辑
      this.$message.info('电话号码验证功能开发中');
    },
    // 验证邮箱
    verifyEmail() {
      // 这里可以添加邮箱验证API调用逻辑
      this.$message.info('邮箱验证功能开发中');
    },
    // 退出登录
    logout() {
      // 清除登录状态和用户信息
      this.isLoggedIn = false;
      this.currentUser = {
        username: '',
        email: '',
        phone: '',
        hotelName: ''
      };
      // 清除localStorage中的登录状态和用户信息
      localStorage.removeItem('isLoggedIn');
      localStorage.removeItem('currentUser');
      // 关闭个人资料弹窗
      this.userProfileVisible = false;
      // 提示用户
      this.$message.success('退出登录成功');
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
    align-items: center;
    justify-content: space-between;
    background-image: linear-gradient(to left, #5185ff, 1px, #5185ff);
    backdrop-filter: blur(8px);
    height: 45px;
    padding: 0 20px;
    box-sizing: border-box;

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
    
    /* 登录注册按钮样式 */
    .auth_buttons {
      display: flex;
      gap: 10px;
      align-items: center;
    }
    
    .login_btn {
      font-size: 14px;
      font-weight: bold;
      background: rgba(255, 255, 255, 0.2);
      border: 1px solid rgba(255, 255, 255, 0.3);
      color: #ffffff;
      
      &:hover {
        background: rgba(255, 255, 255, 0.3) !important;
        border-color: rgba(255, 255, 255, 0.4) !important;
        color: #ffffff !important;
      }
    }
    
    /* 用户信息样式 */
    .user_info {
      display: flex;
      align-items: center;
      gap: 5px;
      padding: 8px 12px;
      border-radius: 4px;
      cursor: pointer;
      transition: all 0.3s ease;
      background: rgba(255, 255, 255, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.2);
      color: #ffffff;
      
      &:hover {
        background: rgba(255, 255, 255, 0.2) !important;
        border-color: rgba(255, 255, 255, 0.3) !important;
      }
      
      .user_name {
        font-size: 14px;
        font-weight: bold;
      }
      
      i {
        font-size: 12px;
        transition: transform 0.3s ease;
      }
    }
  }

  .content {
    width: 100%;

    // 酒店模块标题样式
    .hotel_management_title {
      text-align: center;
      margin-bottom: 30px;
      
      i {
        font-size: 36px;
        color: #3D73E9;
        margin-right: 10px;
        vertical-align: middle;
      }
      
      h2 {
        display: inline-block;
        font-size: 28px;
        color: #303030;
        font-weight: bold;
        margin: 0;
        vertical-align: middle;
      }
    }
    
    // 酒店模块容器样式
    .hotel_management_con {
      display: flex;
      justify-content: center;
      margin-bottom: 30px;
    }
    
    // 酒店模块卡片样式
    .hotel_module {
      background: #ffffff;
      border-radius: 10px;
      box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.08);
      overflow: hidden;
      transition: all 0.3s ease;
      width: 100%;
      max-width: 800px;
      
      &:hover {
        box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.12);
        transform: translateY(-2px);
      }
    }
    
    // 模块头部样式
    .module_header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 20px;
      background: linear-gradient(135deg, #778dfc, #3D73E9);
      color: #ffffff;
      cursor: pointer;
      transition: all 0.3s ease;
      
      &:hover {
        background: linear-gradient(135deg, #6b83fb, #3d8de4);
      }
      
      i:first-child {
        font-size: 24px;
        margin-right: 12px;
      }
      
      h3 {
        margin: 0;
        font-size: 16px;
        font-weight: bold;
        flex: 1;
      }
      
      i:last-child {
        font-size: 16px;
        transition: transform 0.3s ease;
      }
    }
    
    // 模块内容样式
    .module_content {
      padding: 20px;
      background: #fafafa;
      
      .recommendation_grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 15px;
      }
      
      .recommendation_item {
        display: flex;
        align-items: center;
        padding: 15px;
        background: #ffffff;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
        border: 1px solid #e8e8e8;
        
        &:hover {
          background: #e6f0ff;
          border-color: #3D73E9;
          transform: translateY(-2px);
          box-shadow: 0 4px 12px 0 rgba(61, 115, 233, 0.15);
          
          .recommendation_icon {
            background: linear-gradient(135deg, #778dfc, #3D73E9);
            transform: scale(1.1);
          }
          
          .recommendation_info h4 {
            color: #3D73E9;
          }
        }
        
        .recommendation_icon {
          width: 50px;
          height: 50px;
          border-radius: 10px;
          background: linear-gradient(135deg, #f0f0f0, #e0e0e0);
          display: flex;
          align-items: center;
          justify-content: center;
          margin-right: 15px;
          transition: all 0.3s ease;
          flex-shrink: 0;
          
          i {
            font-size: 24px;
            color: #3D73E9;
          }
        }
        
        .recommendation_info {
          flex: 1;
          min-width: 0;
          
          h4 {
            margin: 0 0 5px 0;
            font-size: 15px;
            font-weight: bold;
            color: #303030;
            transition: all 0.3s ease;
          }
          
          p {
            margin: 0;
            font-size: 13px;
            color: #909090;
            line-height: 1.4;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
          }
        }
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

/* 登录注册弹窗样式 */
/deep/ .el-dialog {
  .el-dialog__header {
    background: linear-gradient(135deg, #778dfc, #3D73E9);
    color: #ffffff;
    
    .el-dialog__title {
      color: #ffffff;
      font-weight: bold;
    }
    
    .el-dialog__headerbtn {
      .el-dialog__close {
        color: #ffffff;
        
        &:hover {
          color: #e6f0ff;
        }
      }
    }
  }
  
  .login_submit,
  .register_submit {
    background: linear-gradient(135deg, #778dfc, #3D73E9);
    border: none;
    
    &:hover {
      background: linear-gradient(135deg, #6b83fb, #3d8de4);
    }
  }
  
  .register_tip,
  .login_tip {
    font-size: 14px;
    color: #606266;
    
    a {
      color: #3D73E9;
      text-decoration: none;
      
      &:hover {
        color: #6b83fb;
        text-decoration: underline;
      }
    }
  }
  
  /* 忘记密码样式 */
  .forget_password {
    font-size: 14px;
    color: #3D73E9;
    text-align: right;
    margin-right: 10px;
    font-weight: normal;
    cursor: pointer;
    transition: color 0.3s ease;
    
    &:hover {
      color: #6b83fb;
      text-decoration: underline;
    }
  }
  
  /* 忘记密码弹窗内容样式 */
  .forgot_password_content {
    padding: 20px 0;
    text-align: center;
    
    .forgot_password_text {
      font-size: 16px;
      color: #303030;
      margin-bottom: 20px;
      font-weight: 500;
    }
    
    .forgot_password_phone {
      font-size: 18px;
      color: #3D73E9;
      
      span {
        font-weight: bold;
        margin-left: 10px;
      }
    }
  }
}

/* 平板设备适配 - 每行显示2个推荐项 */
@media (max-width: 1024px) and (min-width: 801px) {
  .hotel_module {
    max-width: 700px;
  }
  
  .module_content {
    padding: 15px;
    
    .recommendation_grid {
      gap: 12px;
    }
    
    .recommendation_item {
      padding: 12px;
      
      .recommendation_icon {
        width: 45px;
        height: 45px;
        
        i {
          font-size: 22px;
        }
      }
      
      .recommendation_info {
        h4 {
          font-size: 14px;
        }
        
        p {
          font-size: 12px;
        }
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
  
  /* AI酒店管理模块响应式样式 */
  .hotel_management_title {
    margin-bottom: 20px;
    
    i {
      font-size: 28px;
      margin-right: 8px;
    }
    
    h2 {
      font-size: 22px;
    }
  }
  
  .hotel_management_con {
    display: flex;
    justify-content: center;
  }
  
  .hotel_module {
    border-radius: 8px;
  }
  
  .module_header {
    padding: 15px;
    
    i:first-child {
      font-size: 20px;
      margin-right: 10px;
    }
    
    h3 {
      font-size: 15px;
    }
  }
  
  .module_content {
    padding: 12px;
    
    .recommendation_grid {
      grid-template-columns: 1fr;
      gap: 12px;
    }
    
    .recommendation_item {
      padding: 12px;
      
      .recommendation_icon {
        width: 45px;
        height: 45px;
        
        i {
          font-size: 20px;
        }
      }
      
      .recommendation_info {
        h4 {
          font-size: 14px;
        }
        
        p {
          font-size: 12px;
        }
      }
    }
  }
}
</style>