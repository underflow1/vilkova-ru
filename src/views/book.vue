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
      buttonShare: undefined,
      buttonPrev: undefined,
      buttonNext: undefined
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
    }
  },

  mounted () {
    this.buttonShare = new MDCRipple(this.$refs.buttonPrev)
    this.buttonPrev = new MDCRipple(this.$refs.buttonPrev)
    this.buttonNext = new MDCRipple(this.$refs.buttonNext)
    this.buttonShare.unbounded = true
    this.buttonPrev.unbounded = true
    this.buttonNext.unbounded = true
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
</style>
