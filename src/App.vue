<template>
  <div id="app">
    <transition name="el-fade-in-linear" mode="out-in">
      <router-view />
    </transition>
  </div>
</template>

<script>
export default {
  name: "HelloWorld",
  components: {},
  data() {
    return {

    };
  },
  mounted() {

  },
  methods: {


  },
};
</script>

<style scoped>
* {
  padding: 0;
  margin: 0;
}

#app {
  height: 100vh;
  width: 100vw;
}
</style>
