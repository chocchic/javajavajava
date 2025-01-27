package com.chocchic.movie.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.chocchic.movie.model.Movie;

public interface MovieRepository extends JpaRepository<Movie, Long> {
	
	@Query("select m, max(mi), avg(coalesce(r.score, 0)), count(distinct r) from Movie m left outer join MovieImage mi on mi.movie = m left outer join Review r on r.movie = m group by m")
	Page<Object[]> getListPage(Pageable pageable);
	
	@Query("select m, max(mi), avg(coalesce(r.score,0)), count(distinct r) from Movie m "
			+"left outer join MovieImage mi on mi.movie = m " 
			+"left outer join Review r on r.movie = m where m.mno = :mno group by mi")
	List<Object []> getMovieAll(@Param("mno") Long mno);
	
}
