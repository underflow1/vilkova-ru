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

    <div
      v-if="data.video"
      class="video-panel"
      ref="videoPanel"
    >
      <button
        ref="buttonVideo"
        @click="showVideoPanel"
        class="mdc-button"
        :class="{ 'hidden': videoState }"
      >
        <i class="mdc-button__icon material-icons">videocam</i>
        <span class="mdc-button__label">Смотреть видео</span>
      </button>

      <transition name="fade">
        <iframe
          ref="videoIframe"
          :src="data.video"
          :class="{ 'visible': videoState, 'hidden': !videoState }"
          frameborder="0"
          width="560"
          height="315"
          allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
          allowfullscreen
        />
      </transition>
    </div>

    <p v-html="contentHtml"/>
    <p v-if="data.note">
      <em>
        {{ data.note }}
      </em>
    </p>
    <img src="@/assets/end.png" style="width: 44px; height: 71px;" class="end"/>
  </div>
</template>

<script>
import { MDCRipple } from '@material/ripple'
import Social from '@/components/social'

export default {
  name: 'Book',
  components: { Social },

  data () {
    return {
      book: this.$root.book,
      videoState: undefined,
      buttonShare: undefined,
      buttonPrev: undefined,
      buttonNext: undefined,
      buttonVideo: undefined
    }
  },

  computed: {
    url: {
      cache: false,
      get () {
        return 'https://vilkova.ru/book/' + this.index
      }
    },

    title: {
      cache: false,
      get () {
        return this.$root.title + ' — стихиИя — ' + this.data.title
      }
    },

    index () {
      return parseInt(this.$route.params.index)
    },

    data () {
      if (this.index < this.book.length) {
        return this.book[this.index]
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
      this.$router.push(`/book/${index}`)
    },

    showVideoPanel () {
      // Determine needed iframe size
      const panelRect = this.$refs.videoPanel.getBoundingClientRect()

      const iframeElem = this.$refs.videoIframe
      const iframeRect = iframeElem.getBoundingClientRect()

      const w = panelRect.width
      const h = iframeRect.height * panelRect.width / iframeRect.width

      iframeElem.style.width = `${w}px`
      iframeElem.style.height = `${h}px`

      this.videoState = true
    }
  },

  mounted () {
    this.buttonShare = new MDCRipple(this.$refs.buttonPrev)
    this.buttonPrev = new MDCRipple(this.$refs.buttonPrev)
    this.buttonNext = new MDCRipple(this.$refs.buttonNext)
    
    this.buttonShare.unbounded = true
    this.buttonPrev.unbounded = true
    this.buttonNext.unbounded = true

    this.buttonVideo = new MDCRipple(this.$refs.buttonVideo)
  },

  destroyed () {
    this.buttonShare.destroy()
    this.buttonPrev.destroy()
    this.buttonNext.destroy()
    this.buttonVideo.destroy()
  }
}
</script>

<style lang="scss">
  @import "~@/assets/theme";
  @import "~@material/button/mdc-button";
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

  .hidden {
    opacity: 0 !important;
    display: none !important;
  }

  .visible {
    opacity: 1 !important;
    display: initial !important;
  }

  .video-panel {
    margin: 2rem 0;
  }
</style>
