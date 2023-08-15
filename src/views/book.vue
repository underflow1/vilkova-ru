<template>
  <div>
    <div class="mdc-layout-grid__inner">
      <div
          class="
          mdc-layout-grid__cell
          mdc-layout-grid__cell--span-2-phone
          mdc-layout-grid__cell--span-6-desktop
        "
      >
        <button
            @click="copyLink()"
            ref="buttonShare"
            class="mdc-icon-button material-icons"

        >
          <social :url="url" :title="title"/>
        </button>
      </div>
      <div
          class="
          mdc-layout-grid__cell
          mdc-layout-grid__cell--span-2-phone
          mdc-layout-grid__cell--span-6-desktop
        "
          style="text-align: right"
      >
        <button
            ref="buttonPrev"
            :disabled="!canGotoPrev"
            @click="goto(-1)"
            class="mdc-icon-button material-icons"
        >
          arrow_back
        </button>
        <button
            ref="buttonNext"
            :disabled="!canGotoNext"
            @click="goto(1)"
            class="mdc-icon-button material-icons"
        >
          arrow_forward
        </button>
      </div>
    </div>

    <h1>{{ data.title }}</h1>
    <br>


    <transition name="fade">
      <div
          v-if="data.video"
          class="video-panel"
          ref="videoPanel"
      >
        <iframe
            ref="videoIframe"
            :src="data.video"
            :class="{ 'visible': videoState }"
            frameborder="0"
            width="560"
            height="315"
            allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
        />
      </div>
    </transition>

    <div v-if="data.image"><img :src="data.image"></div>

    <p v-html="contentHtml"/>
    <p v-if="data.note">
      <em>
        {{ data.note }}
      </em>
    </p>
    <div v-if="data.bottomimage"><img :src="data.bottomimage"></div>
    <div v-if="data.bottomimagesign"><h5>{{data.bottomimagesign}}</h5></div>

    <img src="@/assets/end.png" style="width: 44px; height: 71px;" class="end"/>
  </div>
</template>

<script>
import { MDCRipple } from '@material/ripple'
import Social from '@/components/social'
import copy from 'copy-to-clipboard';

export default {
  name: 'Book',
  components: { Social },

  data () {
    return {
      book: this.$root.book,
      videoState: undefined,
      buttonShare: undefined,
      buttonPrev: undefined,
      buttonNext: undefined
    }
  },

  computed: {
    url: {
      cache: false,
      get () {
        return 'https://vilkova.ru/book/' + this.routeId
      }
    },

    title: {
      cache: false,
      get () {
        return this.$root.title + ' — стихиИя — ' + this.data.title
      }
    },

    routeId () {
      return this.$route.params.index
    },

    index () {
      var routeId = this.routeId;
      var items = this.book;
      var IndexBook = null;
      items.forEach(function (item, i) {
        if (item[routeId]){
          IndexBook = i;
        }
      });
      return parseInt(IndexBook)
    },

    data () {
      if (this.index < this.book.length) {
        return this.book[this.index][this.routeId]
      } else {
        // Elegant ;-)
        location.href = '/'
      }
      return null
    },

    canGotoPrev () {
      return (this.index > 0)
    },

    canGotoNext () {
      return (this.index < this.book.length - 1)
    },

    contentHtml () {
      if (this.data && this.data.content) {
        return this.data.content
            .replace(/\n/g, '<br>')
      } else {
        return null
      }
    }

  },

  watch: {
    index: {
      immediate: true,
      handler (index) {
        this.$parent.setActiveDrawerItem(index + 1)
        document.title = this.title
      }
    }
  },

  methods: {
    goto(step) {
      const index = this.index + step
      var routeId = Object.keys(this.book[index])[0];
      this.$router.push(`/book/${routeId}`)
    },

    showVideo () {
      // Determine needed iframe size
      const panelElem = this.$refs.videoPanel
      const videoElem = this.$refs.videoIframe

      if (panelElem && videoElem) {
        const panelRect = panelElem.getBoundingClientRect()
        const videoRect = videoElem.getBoundingClientRect()

        const w = panelRect.width
        const h = videoRect.height * panelRect.width / videoRect.width

        videoElem.style.width = `${w}px`
        videoElem.style.height = `${h}px`

        this.videoState = true
      }
    },
    copyLink () {
      copy(this.url, {
      });
      this.$notify({
        type: 'success',
        duration: 1000,
        text: 'Ссылка скопирована!'
      });
    }
  },

  mounted () {
    this.buttonShare = new MDCRipple(this.$refs.buttonPrev)
    this.buttonPrev = new MDCRipple(this.$refs.buttonPrev)
    this.buttonNext = new MDCRipple(this.$refs.buttonNext)

    this.buttonShare.unbounded = true
    this.buttonPrev.unbounded = true
    this.buttonNext.unbounded = true

    // Show video if presented
    this.showVideo()
  },

  destroyed () {
    this.buttonShare.destroy()
    this.buttonPrev.destroy()
    this.buttonNext.destroy()
  }
}
</script>

<style lang="scss">
@import "~@/assets/theme";
@import "~@material/icon-button/mdc-icon-button";

hr {
  border: 0;
  background: none;
  border-top: 1px solid #ddd;
}

.end {
  height: auto;
  position: relative;
  top: -2rem;
}

.video-panel {
  margin: 2rem 0;

  iframe {
    opacity: 0;
    display: none;
  }

  iframe.visible {
    opacity: 1;
    display: initial;
  }
}
</style>
