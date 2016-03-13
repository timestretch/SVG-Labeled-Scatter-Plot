class Report

    attr_accessor :minX, :minY, :maxX, :maxY
    attr_accessor :width, :height, :margin

    def initialize
        @margin = 128
        @width = 1600
        @height = 900
    end

    def group(elements, x, y)
        %(<g transform="translate(#{x},#{y})">#{elements}</g>)
    end

    def scale(input)
        (x,y) = input
        xx = (x-minX) / (maxX - minX).to_f
        yy = 1 - (y-minY) / (maxY - minY).to_f
        [margin + xx * (width - margin*2), margin + yy * (height - margin*2)]
    end

    def axes
        (xx, yy) = scale([minX, minY])
        (ww, hh) = scale([maxX, maxY])
        %(\n<rect x="#{xx}" y="#{yy}" width="#{ww - margin}" height="1" />) +
        %(\n<rect x="#{xx}" y="#{margin}" width="1" height="#{height - margin * 2}" />) +
        label(xx, yy + 40, minX.to_s) +
        label(width - margin, yy + 40, maxX.to_s) +
        label(xx - 40, margin, maxY.to_s) +
        label(xx - 40, height - margin, minY.to_s)
    end

    def circleAndLabel(x, y, label)
        (xx, yy) = scale([x,y])
        # Show the x and y coordinates in a tooltip with a title tag
        group( %(<circle cx="0" cy="0" r="10"><title>#{label} (#{x}, #{y})</title></circle>
                <text x="20" y="5">#{label}</text>), xx, yy )
    end

    def label(x, y, label)
        %(<text x="#{x}" y="#{y}">#{label}</text>)
    end

    # data -> [[ x, y, label ]]
	def render(data)

        @minX = data.map { |(x,y,str)| x }.min
        @maxX = data.map { |(x,y,str)| x }.max

        @minY = data.map { |(x,y,str)| y }.min
        @maxY = data.map { |(x,y,str)| y }.max

        %(<svg viewBox="0 0 #{width} #{height}" xmlns="http://www.w3.org/2000/svg">) +
        axes +
        data.map do |(x,y,str)|
            circleAndLabel(x, y, str)
        end.join +
        %(</svg>)

	end


end
