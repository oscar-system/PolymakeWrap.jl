export nv, ne, vertices, edges, has_vertex, has_edge, inneighbors, outneighbors

### Basic characteristics

function nv(g::Graph{T}) where {T}
    return Polymake.nv(g)
end

function ne(g::Graph{T}) where {T}
    return Polymake.ne(g)
end


### Check for edges and nodes with index shift

function has_edge(g::Graph{T}, s::Int64, d::Int64) where {T}
    return Polymake._has_edge(g, s-1, d-1)
end

function has_vertex(g::Graph{T}, v::Int64) where {T}
    return Polymake._has_vertex(g, v-1)
end


### In and out neighbors
function inneighbors(g::Graph{T}, v::Int64) where {T}
    return to_one_based_indexing(Polymake._inneighbors(g, v-1))
end

function outneighbors(g::Graph{T}, v::Int64) where {T}
    return to_one_based_indexing(Polymake._outneighbors(g, v-1))
end

### Iterate over the edges

struct PmGraphEdgeIterator{T} 
    g::Graph{T}
    state::GraphEdgeIterator{T}
    function PmGraphEdgeIterator{T}(G::Graph{T}) where {T}
        return new(G, edgeiterator(G))
    end
end

function edges(g::Graph{T}) where {T}
    return PmGraphEdgeIterator{T}(g)
end

function Base.length(iter::PmGraphEdgeIterator{T}) where {T}
    return ne(iter.g)
end

function Base.iterate(iter::PmGraphEdgeIterator{T}) where {T}
    state = iter.state
    if isdone(state)
        return nothing
    else
        elt = get_element(state)
        increment(state)
        return to_one_based_indexing(elt), nothing
    end
end

function Base.iterate(iter::PmGraphEdgeIterator{T}, ::Nothing) where {T}
    return Base.iterate(iter)
end


### Iterate over the nodes
# Note: ("nodes" in polymake) == ("vertices" in Julia)

struct PmGraphVertexIterator{T} 
    g::Graph{T}
    state::GraphNodeIterator{T}
    function PmGraphVertexIterator{T}(G::Graph{T}) where {T}
        return new(G, nodeiterator(G))
    end
end

function vertices(g::Graph{T}) where {T}
    return PmGraphVertexIterator{T}(g)
end

function Base.length(iter::PmGraphVertexIterator{T}) where {T}
    return nv(iter.g)
end

function Base.iterate(iter::PmGraphVertexIterator{T}) where {T}
    state = iter.state
    if isdone(state)
        return nothing
    else
        elt = get_element(state)
        increment(state)
        return to_one_based_indexing(elt), nothing
    end
end

function Base.iterate(iter::PmGraphVertexIterator{T}, ::Nothing) where {T}
    return Base.iterate(iter)
end
