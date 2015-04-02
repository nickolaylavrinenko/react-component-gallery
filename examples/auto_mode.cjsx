React = require 'react/addons'
ComponentGallery = require '../src/index'
_ = require 'underscore'


module.exports = React.createClass

  getInitialState: ->
    minTargetWidth: 100
    maxTargetWidth: 200
    margin: 10
    children: [
      <div>
        <img src="https://farm1.staticflickr.com/55/148800272_86cffac801_z.jpg" />
        <span style={
          position: "absolute"
          bottom: 0
          width: "100%"
          background: "rgba(0,0,0,0.5)"
          bottom: 0
          left: 0
          "lineHeight": "30px"
          height: "30px"
          padding: "0 10px"
          color: "white"
        }>Sweet label bro</span>
      </div>,
      <img src="https://storage.googleapis.com/relaterocket-logos/nike.com-black@2x.png"/>,
      # <p style={
      #     margin: 0
      #     padding: "5px"}>
      #   Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      #   Vivamus neque massa, sagittis at ex a, suscipit facilisis augue.
      #   In vitae placerat est. Aliquam mollis orci id arcu condimentum gravida.
      # </p>,
    ]

  componentDidMount: ->
    _this = this

    if not window.google
      console.warn 'Google API is not available'
      return

    google.load 'search', 1, {"language" : "en"}

    searchCallback = ->
      searchResponse = this
      searchResults = searchResponse.results || []
      components = searchResults.map (item) =>
        <img src={item.url}/>

      if components.length
        components = React.addons.update(
          _this.state.children,
          $push: components
        )
        components = _.shuffle(components)
        _this.setState {
          children: components
        }

    onLoad = ->
      s = new google.search.ImageSearch()
      s.setResultSetSize google.search.Search.LARGE_RESULTSET
      s.setSearchCompleteCallback s, searchCallback
      s.setNoHtmlGeneration

      getImages = ->
        s.execute 'images portraits'
        # s.execute 'public infographics'

      # stash
      window.moreImages = ->
        getImages()

      # initial load
      getImages()

    google.setOnLoadCallback onLoad

  render: ->
    children = @state.children

    <div>
      <br />
      <h2>Demo 2: Auto mode (auto fitting)</h2>
      <br />
      <h3>Usage:</h3>
      <pre><code>
      {"""
        <ComponentGallery
          mode="auto"
          galleryClassName="gallery"
          rowClassName="row"
          margin=10
          noMarginBottomOnLastRow=true
          minTargetWidth=50
          maxTargetWidth=250>
            <img src="https://example.com/pic1.jpg" />
            <img src="https://example.com/pic2.jpg" />
            <img src="https://example.com/pic3.jpg" />
            <img src="https://example.com/pic4.jpg" />
            <img src="https://example.com/pic5.jpg" />
            <img src="https://example.com/pic6.jpg" />
        </ComponentGallery>
        """}
      </code></pre>
      <br />
      <h3>minTargetWidth</h3>
      <input
        type="range"
        min=50
        max=500
        ref="sliderMin"
        value={@state.minTargetWidth}
        onChange={@onMinTargetWidthChange} />
      <code>{'  '}{@state.minTargetWidth}px</code>
      <br />
      <h3>maxTargetWidth</h3>
      <input
        type="range"
        min=50
        max=500
        ref="sliderMax"
        value={@state.maxTargetWidth}
        onChange={@onMaxTargetWidthChange} />
      <code>{'  '}{@state.maxTargetWidth}px</code>
      <br />
      <h3>margin</h3>
      <input
        type="range"
        min=0
        max=50
        ref="margin"
        value={@state.margin}
        onChange={@onMarginChange} />
      <code>{'  '}{@state.margin}px</code>
      <br />
      <h3>More images</h3>
      <input
        type="button"
        onClick={@onButtonClick}
        value="Click to add more"/>
      <br />
      <br />
      <h3>Components</h3>
      <ComponentGallery
          mode="auto"
          galleryClassName={"auto-gallery"}
          rowClassName={"auto-gallery-row"}
          margin={parseInt(@state.margin, 10)}
          noMarginBottomOnLastRow=true
          minTargetWidth={parseInt(@state.minTargetWidth, 10)}
          maxTargetWidth={parseInt(@state.maxTargetWidth, 10)}>
        {children}
      </ComponentGallery>
    </div>

  onMaxTargetWidthChange: (e) ->
    minValue = parseInt @refs.sliderMin.getDOMNode().value
    maxValue = parseInt @refs.sliderMax.getDOMNode().value
    state = 
      maxTargetWidth: maxValue
    if maxValue < minValue
      state.minTargetWidth = maxValue
    @setState state


  onMinTargetWidthChange: (e) ->
    minValue = parseInt @refs.sliderMin.getDOMNode().value
    maxValue = parseInt @refs.sliderMax.getDOMNode().value
    state = 
      minTargetWidth: minValue
    if minValue > maxValue
      state.maxTargetWidth = minValue
    @setState state

  onMarginChange: (e) ->
    @setState margin: @refs.margin.getDOMNode().value

  onButtonClick: ->
    if window.moreImages
      window.moreImages()
