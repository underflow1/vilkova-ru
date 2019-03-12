<template>
  <social-sharing
    :url="url"
    :title="title"
    inline-template
  >
    <network network="facebook">
      share
    </network>
  </social-sharing>
</template>

<script>
import Vue from 'vue'
import Social from 'vue-social-sharing'
Vue.use(Social)

export default {
  name: 'Social',
  props: ['url', 'title']
}
</script>
