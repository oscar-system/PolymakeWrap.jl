@testset "Polymake.Graph" begin

    @testset "Directed" begin
        square = Polymake.polytope.cube(2);
        gd = square.HASSE_DIAGRAM.ADJACENCY;
        @test gd isa Polymake.Graph{Polymake.Directed}
        @test Polymake.edges(gd) isa Polymake.PmGraphEdgeIterator{Polymake.Directed}
        @test Polymake.vertices(gd) isa Polymake.PmGraphVertexIterator{Polymake.Directed}
        @test Polymake.nv(gd) == 10
        @test Polymake.ne(gd) == 16
        @test Polymake.has_vertex(gd, 1)
        @test collect(Polymake.outneighbors(gd, 1)) == [2;3;4;5]
        @test collect(Polymake.inneighbors(gd, 2)) == [1]
        @test collect(Polymake.vertices(gd)) == [1;2;3;4;5;6;7;8;9;10]
        @test size(collect(Polymake.edges(gd))) == (16,)
    end
    
    @testset "Undirected" begin
        complete = Polymake.graph.complete(4)
        gu = complete.ADJACENCY
        @test gu isa Polymake.Graph{Polymake.Undirected}
        @test Polymake.edges(gu) isa Polymake.PmGraphEdgeIterator{Polymake.Undirected}
        @test Polymake.vertices(gu) isa Polymake.PmGraphVertexIterator{Polymake.Undirected}
        @test Polymake.nv(gu) == 4
        @test Polymake.ne(gu) == 6
        @test Polymake.has_vertex(gu, 1)
        @test collect(Polymake.outneighbors(gu, 2)) == [1;3;4]
        @test Polymake.outneighbors(gu,2) == Polymake.inneighbors(gu,2)
        @test collect(Polymake.vertices(gu)) == [1;2;3;4]
        @test size(collect(Polymake.edges(gu))) == (6,)
    end

end
